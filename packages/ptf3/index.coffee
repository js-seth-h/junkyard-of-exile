dcon = require('deco-console')(__filename)
R = require 'ramda'
RA = require 'ramda-adjunct'


# USE_LANG = ['English']
# MARGIN_RATE = 0.2

class Facade
  setRefData: (rule_obj, refs)->
    Object.assign this, R.clone refs
    @version = rule_obj.version
    I18N.loadData refs
    MOD.loadRule rule_obj.list
  setLang: (lang)->
    I18N.setLang lang
    MOD.setLang lang
    # USE_LANG = R.uniq [@lang, 'English' ]
  parseItemText: (item_text)->
    blocks = R.map R.trim, R.split '--------', item_text
    builder = new Builder
    for blk in  blocks
      builder.feed blk
    return builder.item
  forBackend: (item_data)->
    req_lv = item_data.requirement.Level
    list = R.flatten R.values item_data.mod
    list = R.filter R.propEq('know', true), list
    coded = list.map ({rep_inx, value})->
      return [rep_inx, value]
    return {req_lv, coded}


module.exports = exports = new Facade

class ModDetector
  loadRule: (list)->
    _newRep = (rep)-> new Representative rep
    @rep_list = R.map _newRep, list
  setLang: (lang)->
    @use_langs = R.uniq [lang, 'English' ]

  detect: (blk_text)->
    mods = []
    for rep, rep_inx in @rep_list
      match = rep.test blk_text
      continue unless match?
      {str, value} = match
      # console.log {match}
      n = R.indexOf str, blk_text
      mods.push {know: true, str, value, rep_inx, n }
    if mods.length is 0
      return null
    unknown = blk_text
    mods = R.sort R.ascend(R.prop 'n'), mods
    for {str} in mods
      unknown = unknown.replace str, ''
      unknown = unknown.replace /\n\n/, '\n'
    unknown = R.trim unknown
    unless R.isEmpty unknown
      mods.push {
        know: false, str: unknown
      }
    ma = /\((.+?)\)$/.exec R.head(mods).str
    if ma?
      mod_group = Array.from(ma)[1]
    else
      mod_group = 'explict'
    result = R.objOf mod_group, mods
    # dcon.F.debug result
    return result # {unknown, mods}
    # return new PtfResult item_text, match_list, req_lv

MOD = new ModDetector

class I18nConverter
  loadData: (refs)->
    @tbl = mergeDeepAll R.values refs
  setLang: (@lang)->
  word: (text)=>
    id = @tbl[@lang][text]
  list: (list)=>
    list.map (it)=> @tbl[@lang][it] or it


I18N = new I18nConverter
trimAll = R.map R.trim
class Builder
  constructor:()->
    @item = {}
    @blk_inx = 0
    # @block.push asHeader blk

  feed: (blk)->
    lines = R.split '\n', blk
    maybeSign = I18N.word R.head R.split ':', lines[0]
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
        if @blk_inx is 1
          @setProperty lines
        else if mod_group = @tryParseMods blk
          @item.mod ?= {}
          Object.assign @item.mod, mod_group
        else
          @item.unknown_block ?= []
          @item.unknown_block.push blk
          dcon.F.debug {maybeSign, ln: R.head lines}

    @blk_inx++

  tryParseMods: (blk)->
    MOD.detect blk
    # match_list = []
    # for rep in @rep_list
    #   match = rep.test item_text
    #   continue unless match?
    #   {str, value} = match
    #   console.log {match}
    #   match_list.push {rep, str, value}


  setHeader: (lines)->
    [_, item_class] = I18N.list trimAll R.split ':', lines[0]
    [_, rarity] = I18N.list trimAll R.split ':', lines[1]

    is_rare = rarity is 'ItemDisplayStringRare'
    base_type = lines[3] if is_rare
    name = lines[2]
    Object.assign @item, {
      # lines
      name
      is_rare
      item_class
      base_type
      headers: lines
    }

  setProperty: (lines)->
    properties = lines
    props = {}
    for ln in lines
      if R.includes ':', ln
        [name, value] = I18N.list trimAll R.split ':', ln
        props[name] = value
    Object.assign @item, {
      properties
      props
    }
  setSocket: (lines)->
    [name, value] = trimAll R.split ':', R.head lines
    # dcon.F.debug 'socket lins',value
    @item.sockets = value

  setRequirement: (lines)->
    requirement = {}
    for ln in R.tail lines
      [name, value] = I18N.list trimAll R.split ':', ln
      requirement[name] = if /^\d+$/.test value
        parseInt value
      else
        value
    Object.assign @item, {
      requirement
    }
  setItemLevel: (lines)->
    [name, value] = trimAll R.split ':', R.head lines
    # dcon.F.debug 'socket lins',value
    @item.ilvl = parseInt value

  setNote: (lines)->
    [name, value] = trimAll R.split ':', R.head lines
    # dcon.F.debug 'socket lins',value
    @item.note = value

mergeDeepAll = R.reduce(R.mergeDeepRight, {})



MARGIN_RATE = 0.2
class Representative
  constructor: (cfg)->
    Object.assign this, R.clone cfg
    for localize in @i18n
      {text: exp} = localize
      exp = exp.replace /\+/g, '\\+'
      exp = exp.replace /\#/g, "([+-\d]+)"
      localize.regexp = new RegExp '^' + exp + '( \\(\\S+\\))?$', 'gm'
  test: (item_text)->
    for localize in @i18n
      {regexp, lang} = localize
      continue unless lang in MOD.use_langs
      regexp.lastIndex = 0
      match = regexp.exec item_text
      continue unless match?
      ma = Array.from match
      # console.log ma
      str = R.head ma
      values = ma.splice 1, @sharp_cnt
      values = R.map parseFloat, values
      value = R.sum(values) / values.length
      return {
        str, value
      }
    return null
  getTradeFilters: (value)->
    filters = R.map R.pick(['id']), @trade_opts
    unless Number.isNaN value
      min = value * (1 - MARGIN_RATE)
      max = value * (1 + MARGIN_RATE)
      for f in filters
        Object.assign f, value: {min, max}

    return filters

# Object.assign exports, {
#   setRules
# }
