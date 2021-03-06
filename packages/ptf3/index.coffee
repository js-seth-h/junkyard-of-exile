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
  setLang: (@lang)->
    I18N.setLang @lang
    MOD.setLang @lang
    # USE_LANG = R.uniq [@lang, 'English' ]
  parseItemText: (item_text)->
    blocks = R.map R.trim, R.split '--------', item_text
    builder = new Builder
    for blk in  blocks
      builder.feed blk

    bt = @basetypes.find (bt)=> bt.i18n[@lang] is builder.item.header.base_type
    builder.item.basetype = bt
    return builder.item
  forBackend: (item_data)->
    req_lv = item_data.requirement?.Level or 1
    mod_blk = R.filter R.propEq('blk_type', 'mod'), R.values item_data
    # list = R.flatten R.values item_data.mod
    list = R.flatten R.map R.prop('mods'), mod_blk
    list = R.filter R.propEq('know', true), list
    # tbl = {}
    # for {rep_inx, value} in list
    #   tbl[rep_inx] ?= 0
    #   tbl[rep_inx] += value
    # coded = R.zip R.map(parseInt,R.keys(tbl)), R.values(tbl)
    coded = R.flatten list.map ({found_num, rep_inx, value})->
      return [found_num, rep_inx, value]
    return {req_lv, coded}

  applyEvaluate: (item_data, evaled)->
    {t:tradable, p:power, f:fullness, r: ratings} = evaled
    mod_blk = R.filter R.propEq('blk_type', 'mod'), R.values item_data
    mods = R.flatten R.map R.prop('mods'), mod_blk
    ratings = R.splitEvery 2, ratings
    item_data.fullness = fullness
    item_data.power = power
    item_data.tradable = tradable
    for m in mods
      {found_num} = m
      r = ratings.find (r)-> r[0] is found_num
      m.rating = if r?
        r[1]
      else
        "X"
  applyTradeResult: ()->
  forTrade: (item_data)->
    condition_cnt = 0
    # [target_ratings] = R.splitAt rating_cnt, 'SABCDF'
    # dcon.F.debug 'target_ratings', target_ratings
    {item_class} = item_data.header
    stats = []
    stats.push {
      type: "and"
      filters: []
    }
    mod_blk = R.filter R.propEq('blk_type', 'mod'), R.values item_data
    # dcon.F.debug {mod_blk}
    for blk in mod_blk
      {mod_group, mods} = blk
      for m in R.filter R.propEq('know', true), mods
        # dcon.F.debug m, m.rating in target_ratings
        rep = MOD.getRep m.rep_inx
        filter = rep.forTradeSimple m.value, mod_group, item_class
        # if not R.includes m.rating, target_ratings
        if m.use_trade is false
          filter.disabled = true
        stats[0].filters.push filter
        condition_cnt++
    if condition_cnt is 0
      return null
    return result =
      sort: price: 'asc'
      query: {
        filters:
          type_filters: {
            filters:  rarity:"option": "rare"
            disabled: false
          }
        status: option: "online"
        stats
      }

module.exports = exports = new Facade

class ModDetector
  loadRule: (list)->
    _newRep = (rep)-> new Representative rep
    @rep_list = R.map _newRep, list
    for rep, inx in @rep_list
      rep.inx = inx
  setLang: (lang)->
    @use_langs = R.uniq [lang, 'English' ]

  getRep:(rep_inx)->
    @rep_list[rep_inx]
  detect: (blk_text)->
    mods = []
    for rep, rep_inx in @rep_list
      match = rep.test blk_text
      continue unless match?
      {str, value} = match
      # console.log {match}
      n = R.indexOf str, blk_text
      ma = /\((.+?)\)$/.exec str
      if ma?
        mod_group = Array.from(ma)[1]
      else
        mod_group = 'explicit'
      mods.push {know: true, str, rating: '?', use_trade: true,  value, rep_inx, n, mod_group }
    if mods.length is 0
      return null

    mod_group = if R.includes 'explicit', mods.map (m)-> m.mod_group
      'explicit'
    else
      mods[0].mod_group

    unknown = blk_text
    mods = R.sort R.ascend(R.prop 'n'), mods
    for {str} in mods
      unknown = unknown.replace str, ''
      unknown = unknown.replace /\n\n/, '\n'
    unknown = R.trim unknown
    unless R.isEmpty unknown
      mods.push {
        know: false, str: unknown, rating: "X", use_trade: false, mod_group
      }
    # ma = /\((.+?)\)$/.exec R.head(mods).str
    # if ma?
    #   mod_group = Array.from(ma)[1]
    # else
    #   mod_group = 'explicit'

    return {mod_group, mods}

MOD = new ModDetector

class I18nConverter
  loadData: (refs)->
    @tbl = mergeDeepAll R.values refs

    ks = R.keys @tbl['English']
    vs = R.values @tbl['English']
    @id_to_eng_tbl = R.zipObj vs, ks

  setLang: (@lang)->
  word: (text)=>
    id = @tbl[@lang][text]
  toEng: (id)=>
    return @id_to_eng_tbl[id]
  list: (list)=>
    list.map (it)=> @tbl[@lang][it] or it


I18N = new I18nConverter
trimAll = R.map R.trim
class Builder
  constructor:()->
    @block_order = []
    @item = {
      @block_order
      tradable: "not yet measure"
      power: "not yet measure"
      fullness: "not yet measure"
    }
    @found_num = 0

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
          # @item.unknown_block ?= []
          # @item.unknown_block.push blk
          # dcon.F.debug {maybeSign, ln: R.head lines}

  trySetMods: (blk)->
    result = MOD.detect blk
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
    @item.block_order.push key_name
    @item[key_name] = blk
    return true

  setHeader: (lines)->
    blk = {
      blk_type: 'header', lines
    }

    [_, item_class] = I18N.list trimAll R.split ':', lines[0]
    [_, rarity] = I18N.list trimAll R.split ':', lines[1]
    is_rare = rarity is 'ItemDisplayStringRare'
    name = lines[2]
    base_type = lines[3] if is_rare
    Object.assign blk, {
      name
      rarity
      item_class
      base_type
    }
    @item.block_order.push blk.blk_type
    @item[blk.blk_type] = blk

  setProperty: (lines)->
    blk = {
      blk_type: 'property', lines
    }
    for ln in lines
      if R.includes ':', ln
        [name, value] = I18N.list trimAll R.split ':', ln
        blk[I18N.toEng name] = value
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
      [name, value] = I18N.list trimAll R.split ':', ln
      blk[I18N.toEng name] = if /^\d+$/.test value
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
  getTradeFilters: (value, mod_group)->
    filters = R.filter R.o(R.includes(mod_group), R.prop('id')), @trade_opts
    filters = R.map R.pick(['id']), filters
    unless Number.isNaN value
      min = value * (1 - MARGIN_RATE)
      max = value * (1 + MARGIN_RATE)
      for f in filters
        Object.assign f, value: {min, max}

    return filters
  forTradeSimple: (value, mod_group, item_class)->
    # filters = R.filter R.o(R.includes(mod_group), R.prop('id')), @trade_opts
    is_local = R.includes item_class, @locality

    filter = R.pick ['id'], @trade_opts.find (f)->
      return false if mod_group isnt f.type
      return false if f.tag is 'Local' and is_local is false
      return true

    # filter = R.clone R.head filters
    # dcon.F.debug this, 'forTradeSimple', mod_group, '>>', filter
    unless Number.isNaN value
      min = value * (1 - MARGIN_RATE)
      max = value * (1 + MARGIN_RATE)
      if value > 0
        filter.value = {min}
      else
        filter.value = {max: min}
    return filter
# Object.assign exports, {
#   setRules
# }
