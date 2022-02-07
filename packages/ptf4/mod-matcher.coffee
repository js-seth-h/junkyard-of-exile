dcon = require('deco-console')(__filename)
R = require 'ramda'
RA = require 'ramda-adjunct'

 

class ModMatcher  
  setPreData: (@list)->
    for it in @list 
      exp = it.str
      exp = exp.replace /\+/g, '\\+'
      exp = exp.replace /\#/g, "([+-\d]+)"
      it.regexp = new RegExp '^' + exp + '( \\(\\S+\\))?$', 'gm'
      
      it.sharp_cnt = R.length R.filter R.equals('#'), it.str


  test: (sword, item_text)-> 
    {regexp} = sword
    regexp.lastIndex = 0
    match = regexp.exec item_text
    unless match?
      return null
    ma = Array.from match
    # console.log ma
    str = R.head ma
    values = ma.splice 1, @sharp_cnt
    values = R.map parseFloat, values
    value = R.sum(values) / values.length
    return {
      str, value
    }

  getModType: (blk_text)->
    ma = /\((.+?)\)$/.exec blk_text
    if ma?
      mod_group = Array.from(ma)[1]
    else
      mod_group = 'explicit'
    return mod_group

  extractModBlock: (lang, blk_text)->
    mod_group = @getModType blk_text

    mods = []
    list = @list.filter (it)->
      R.includes lang, it.langs

    for it in list 
      {regexp} = it  
      regexp.lastIndex = 0
      match = regexp.exec blk_text
      continue unless match?
      ma = Array.from match
      dcon.F.debug 'ma', ma
      str = R.head ma
      values = ma.splice 1, it.sharp_cnt
      values = R.map parseFloat, values
      value = R.sum(values) / values.length
      mods.push { know: true, str, value, rating: "?", word_inx: it.word_inx }

    unknown = blk_text
    mods = R.sort R.ascend(R.prop 'n'), mods
    for {str} in mods
      unknown = unknown.replace str, ''
      unknown = unknown.replace /\n\n/, '\n'
    unknown = R.trim unknown
    unless R.isEmpty unknown
      mods.push {
        know: false, str: unknown, rating: "X"
      }

    return {
      blk_type: 'mod'
      mod_group, mods
    }

    # mods = []
    # for rep, rep_inx in @rep_list
    #   match = rep.test blk_text
    #   continue unless match?
    #   {str, value} = match
    #   # console.log {match}
    #   n = R.indexOf str, blk_text
    #   ma = /\((.+?)\)$/.exec str
    #   if ma?
    #     mod_group = Array.from(ma)[1]
    #   else
    #     mod_group = 'explicit'
    #   mods.push {know: true, str, rating: '?', use_trade: true,  value, rep_inx, n, mod_group }
    # if mods.length is 0
    #   return null

    # mod_group = if R.includes 'explicit', mods.map (m)-> m.mod_group
    #   'explicit'
    # else
    #   mods[0].mod_group

    # unknown = blk_text
    # mods = R.sort R.ascend(R.prop 'n'), mods
    # for {str} in mods
    #   unknown = unknown.replace str, ''
    #   unknown = unknown.replace /\n\n/, '\n'
    # unknown = R.trim unknown
    # unless R.isEmpty unknown
    #   mods.push {
    #     know: false, str: unknown, rating: "X", use_trade: false, mod_group
    #   }
    # # ma = /\((.+?)\)$/.exec R.head(mods).str
    # # if ma?
    # #   mod_group = Array.from(ma)[1]
    # # else
    # #   mod_group = 'explicit'

    # return {mod_group, mods}


module.exports = exports = new ModMatcher
