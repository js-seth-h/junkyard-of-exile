dcon = require('deco-console')(__filename)
R = require 'ramda'
RA = require 'ramda-adjunct'


# USE_LANG = ['English']
# MARGIN_RATE = 0.2

{Builder} = require './builder'
MM = require './mod-matcher'

class Facade
  setRefData: (@refs)->
    # @version = rule_obj.version
    # I18N.loadData refs
    # MOD.loadRule rule_obj.list
    MM.setPreData @refs.MOD_WORDS
  setLang: (@lang)->
    # I18N.setLang @lang
    # MOD.setLang @lang

    # USE_LANG = R.uniq [@lang, 'English' ]
  parseItemText: (item_text)->
    blocks = R.map R.trim, R.split '--------', item_text
    # USE_LANGS = R.uniq [lang, 'English' ]
    builder = new Builder @refs, @lang
    for blk in  blocks
      builder.feed blk 

    bt = @refs.BASETYPES.find (bt)=> 
      bt.i18n[@lang] is builder.item.header.base_type
    builder.item.basetype = bt 
    # builder.item.header.item_class = bt.class_name
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
    coded = list.map ({found_num, word_inx, value})->
      return [found_num, word_inx, value]
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

  forTrade: (item_data)->
    # 우선 고정 처리
    return result =
      sort: price: 'asc'
      query: {
        filters:
          type_filters: {
            filters:  rarity:"option": "rare"
            disabled: false
          }
        status: option: "online" 
        stats:[{"type":"and","filters":[{"id":"pseudo.pseudo_total_cold_resistance"}]}]
      }


module.exports = exports = new Facade
