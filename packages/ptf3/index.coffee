dcon = require('deco-console')(__filename)
R = require 'ramda'
RA = require 'ramda-adjunct'


USE_LANG = ['English']
MARGIN_RATE = 0.2

class PtfResult
  constructor: (@item_text, @components, @req_lv)->

  forTrade: ()->
    stats = []
    for {rep, value} in @components
      filters = rep.getTradeFilters value
      stats.push {
        filters
        type: 'count'
        value: min: 1
        disabled: false
      }
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
        # stats: [
        #   stats[0]
        #   stats[1]
        #   stats[2]
        #   stats[3]
        #   stats[4]
        #   stats[5]
        #   stats[6]
        # ]
      }

  forBackend: ()->
    coded = @components.map ({rep, value})->
      return [rep.inx, value]
    return {@req_lv, coded}

class Parser
  setRule: (rule_obj)->
    @version = rule_obj.version
    @rep_list = R.map newRepresentative, rule_obj.list
  setLang: (lang)->
    USE_LANG = R.uniq [lang, 'English' ]

  parseItemText: (item_text)->
    blocks = R.map R.trim, R.split '--------', item_text
  # blocks = R.map R.split('\n'), blocks

    req_blk = R.find R.startsWith('요구사항:'), blocks
    dcon.F.debug {req_blk}
    lines = R.split '\n', req_blk
    dcon.F.debug {lines}
    pairs = R.map R.o(R.map(R.trim), R.split(':')), lines
    req_tbl = R.fromPairs pairs
    dcon.F.debug {blocks, pairs, req_tbl}
    req_lv = parseInt req_tbl['레벨']



    match_list = []
    for rep in @rep_list
      match = rep.test item_text
      continue unless match?
      {str, value} = match
      console.log {match}
      match_list.push {rep, str, value}

    return new PtfResult item_text, match_list, req_lv


newRepresentative = (rep)-> new Representative rep

class Representative
  constructor: (cfg)->
    Object.assign this, R.clone cfg
    for localize in @i18n
      {representative: exp} = localize
      exp = exp.replace /\+/g, '\\+'
      exp = exp.replace /\#/g, "([+-\d]+)"
      localize.regexp = new RegExp '^' + exp + '( \\(\\S+\\))?$', 'gm'
  test: (item_text)->
    for localize in @i18n
      {regexp, lang} = localize
      continue unless lang in USE_LANG
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
module.exports = exports = new Parser

# Object.assign exports, {
#   setRules
# }
