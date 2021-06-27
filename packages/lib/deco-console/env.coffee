# console.log 'r', require
# console.log 'm', require 'moment'
# console.log 'm/m', require 'moment/moment'

R = require 'ramda'
c = require 'ansi-colors'

color_set = [
  c.red
  c.green
  c.blue
  c.yellow
  c.magenta
  c.cyan

  c.redBright
  c.greenBright
  c.blueBright
  c.yellowBright
  c.magentaBright
  c.cyanBright

  c.dim.red
  c.dim.green
  c.dim.blue
  c.dim.yellow
  c.dim.magenta
  c.dim.cyan

  c.dim.redBright
  c.dim.greenBright
  c.dim.blueBright
  c.dim.yellowBright
  c.dim.magentaBright
  c.dim.cyanBright
]


MODULE_ID_CACHE = {}
moduleId = (filepath)->
  filepath = R.replace /\\/gm, '/', filepath

  if MODULE_ID_CACHE[filepath]?
    return MODULE_ID_CACHE[filepath]
  return makeShort filepath


N_C_INX = 0
coloring = R.memoizeWith R.identity, (word)->
  fn = color_set[N_C_INX]
  N_C_INX++
  N_C_INX = 0 if N_C_INX >= color_set.length
  return fn word


START_MMT = (new Date()).getTime()
moment = require 'moment'
getDT =
  S: ->
    dr = moment.duration(moment().diff(START_MMT))
    dr.asSeconds().toFixed(3).padStart(8)
  T: ->
    moment().format('HH:mm:ss.SSS')
  LT: ->
    moment().format('YYYY-MM-DD HH:mm:ss.SSS')

formatDatetime = (fmt)->
  # console.log "'getDT_'+ fmt", 'getDT_'+ fmt
  unless getDT[fmt]
    throw new Error 'Wrong formatDatetime()'
  exports.dt = getDT[fmt]

setDetail = (detail)->
  if detail is 0 # Disable All
    exports.onoff ={
      error: off
      info: off
      warn: off
      log: off
      debug: off
    }
  else if detail is 1 # Disable All, except info, error
    exports.onoff ={
      error: on
      info: on
      warn: off
      log: off
      debug: off
    }
  else if detail is 2 # + warn, log(verb)
    exports.onoff ={
      error: on
      info: on
      warn: on
      log: on
      debug: off
    }
  else
  # if detail is 3 # + debug
    exports.onoff ={
      error: on
      info: on
      warn: on
      log: on
      debug: on
    }


shorters = []
makeShort = (filepath)->
  fn = R.pipe shorters...
  fn filepath

shorten = (fn)->
  shorters.push fn



shorten (p)-> p.replace /.+node_modules\//, ''
shorten (p)-> p.replace /(\.[^.+]+)$/, ''

Object.assign exports, {
  moduleId
  coloring
  dt: getDT.S
  onoff: {
    # error: on
    warn: off
    # info: on
    log: off
    debug: off
  }
  # setOpts
  shorten
  detail: setDetail
  formatDatetime

  # getDT_S
  # getDT_T
  # getDT_LT

}

if window?
  window.DCON_ENV = exports
