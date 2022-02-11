dcon = require('deco-console')(__filename)
R = require 'ramda'
RA = require 'ramda-adjunct'
CC = require 'change-case'

MM = require './mod-matcher'

trimAll = R.map R.trim

class Builder
  constructor:(@refs, @use_lang)->
    @block_order = []
    @item = {
      @block_order
      tradable: "not yet measure"
      power: "not yet measure"
      fullness: "not yet measure"
    }
    @found_num = 0
  toFieldName: (it)=>
    dcon.F.debug 'toFieldName', it 
    for own eng, code of @refs.KEYWORDS['English']
      if code is it 
        return CC.snakeCase eng 
    return 'UNKNOWN_FIELD'


  toI18n: (it)=>
    reserved_word = @refs.KEYWORDS[@use_lang][it]
    reserved_word ?= @refs.KEYWORDS['English'][it]
    return reserved_word
  toI18nList: (words)=>
    dcon.F.debug 'toI18nList:: words', words
    list = words.map (it)=> 
      w = @toI18n it
      return w or it 
    dcon.F.debug 'toI18nList:: to list', list
    return list
  feed: (blk)->
    lines = R.split '\n', blk
    dcon.F.debug 'lines', lines
    maybeSign = @toI18n R.head R.split ':', lines[0]
    switch maybeSign
      when 'ItemDisplayStringClass'
        @setHeader lines
      when 'ItemDisplayStringSockets'
        @setSocket lines
      when 'ItemPopupRequirements'
        @setRequirement lines
      when 'ItemDisplayStringItemLevel'
        @setItemLevel lines
      when 'ItemDisplayStringNote'
        @setNote lines
      else
        # console.log '@block_order.length', @block_order.length
        if @block_order.length is 1
          @setProperty lines
        else if can_set = @trySetMods blk
          # @item.mod ?= {}
          # Object.assign @item.mod, mod_group
        else

          bname = 'block_'+ @block_order.length
          @item.block_order.push bname
          @item[bname] = {
            lines
          }
 
  setHeader: (lines)->
    blk = {
      blk_type: 'header', lines
    }


    dcon.F.debug 'setHeader lines[0]', lines[0], trimAll R.split ':', lines[0]
    dcon.F.debug 'setHeader lines[0]', @toI18nList trimAll R.split ':', lines[0]

    [_, item_class] = trimAll R.split ':', lines[0]
    [_, rarity] = trimAll R.split ':', lines[1]
    is_rare = 'ItemDisplayStringRare' is @toI18n rarity
    name = lines[2]
    base_type = lines[3] if is_rare
    Object.assign blk, {
      name
      rarity
      item_class
      base_type
    }
    @item.is_rare = is_rare
    @item.block_order.push blk.blk_type
    @item[blk.blk_type] = blk

  setProperty: (lines)->
    blk = {
      blk_type: 'property', lines
    }
    for ln in lines
      if R.includes ':', ln
        [name, value] = @toI18nList trimAll R.split ':', ln
        blk[@toFieldName name] = value
    @item.block_order.push blk.blk_type
    @item[blk.blk_type] = blk

  setSocket: (lines)->
    blk = {
      blk_type: 'sockets', lines
    }
    [name, value] = trimAll R.split ':', R.head lines
    blk.value = value
    @item.block_order.push blk.blk_type
    @item[blk.blk_type] = blk

  setRequirement: (lines)->
    blk = {
      blk_type: 'requirement', lines
    }
    for ln in R.tail lines
      [name, value] = @toI18nList trimAll R.split ':', ln
      blk[@toFieldName name] = if /^\d+$/.test value
        parseInt value
      else
        value
    @item.block_order.push blk.blk_type
    @item[blk.blk_type] = blk

  setItemLevel: (lines)->
    blk = {
      blk_type: 'item_level', lines
    }
    [name, value] = trimAll R.split ':', R.head lines
    blk.value = value
    @item.block_order.push blk.blk_type
    @item[blk.blk_type] = blk

  setNote: (lines)->
    blk = {
      blk_type: 'note', lines
    }
    [name, value] = trimAll R.split ':', R.head lines
    blk.value = value
    @item.block_order.push blk.blk_type
    @item[blk.blk_type] = blk

  # trySetMods: (blk)->
  #   result = MOD.detect blk
  #   return false unless result?
  #   key_name = result.mod_group + '_mods'
  #   if @item[key_name]?
  #     key_name = 'mod' + @block_order.length
  #   for m in result.mods
  #     m.found_num = @found_num
  #     @found_num++
  #   blk = {
  #     blk_type: 'mod'
  #   }
  #   Object.assign blk, result
  #   @item.block_order.push key_name
  #   @item[key_name] = blk
  #   return true

  trySetMods: (blk)->
    result = MM.extractModBlock @use_lang, blk
    return false unless result?
    key_name = result.mod_group + '_mods'
    if @item[key_name]?
      key_name = 'mod' + @block_order.length
    for m in result.mods
      m.found_num = @found_num
      @found_num++
    blk = {
      blk_type: 'mod'
    }
    Object.assign blk, result

    dcon.F.debug 'trySetMods', blk
    @item.block_order.push key_name
    @item[key_name] = blk
    return true
    
Object.assign exports, {
  Builder
} 