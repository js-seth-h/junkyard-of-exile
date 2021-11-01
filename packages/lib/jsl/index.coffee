R = require 'ramda'
RA = require 'ramda-adjunct'
dcon = require('deco-console')(__filename)
ms = require 'ms'
moment = require 'moment'

travel = require './lib/travel'
convert = require './lib/convert'

Error::with = (props = {})->
  Object.assign this, props
  return this
Error::toBe = (msg, props = {})->
  # @previous_messages ?= []
  # @previous_messages.push @message
  @full_message = msg + '; ' + @message
  @stack = @stack.replace @message, @full_message
  @message = msg
  Object.assign this, props
  dcon.debug 'toBe?', this, @message
  return this

Error::toJSON = ()->
  # json = JSON.parse JSON.stringify obj
  json = {}
  Object.assign json, this, {
    message: @message
    stack: @stack
  }
  return json

Error.fromJSON = (json)->
  e = new Error json.message
  Object.assign e, json
  return e


waitOnce = (emitter, event_name)->
  console.log {emitter}
  new Promise (done)->
    adder = emitter.on or emitter.addListener or emitter.addEventListener
    remover = emitter.off or emitter.removeListener or emitter.removeEventListener
    handler = (args...)->
      remover.call emitter, event_name, handler
      done args
    adder.call emitter, event_name, handler

class Deferred
  constructor: ->
    @promise = new Promise (resolve, reject)=>
      @reject = reject
      @resolve = resolve
globalThis.Deferred = Deferred


postpone = (str)->
  new Promise (_t)-> setTimeout _t, ms str

throwTimeoutAfter = (str)->
  new Promise (_ok, _reject)->
    _dfn = -> _reject new Error 'Timeout'
    setTimeout _dfn, ms str


parseBool = (value)->
  return value if typeof value is 'boolean'
  value = String value
  truthy = [ 'true', 't', 'yes', 'y', 'on', '1' ]
  return truthy.includes(value.trim().toLowerCase())

PromiseProps = (obj)->
  await Promise.all Object.values obj
  result = {}
  for own key, p of obj
    result[key] = await p
  return result
# chErrMsg = (err, msg)->
#   err.message = msg + '; ' + err.message
#   return err


retry = R.curry (opt, fn)->
  if R.is Number, opt
    [retry, delay_str] = [opt, '50ms']
  else
    {retry, delay_str} = R.mergeLeft opt, {
      delay_str: '50ms'
    }

  catched_error = null
  while retry > 0
    try
      return await fn()
    catch error
      catched_error = error
    retry--
    if retry > 0
      await postpone delay_str
      # await delayMilSec delay_ms
  throw catched_error

squash = (opt)->
  pendings = null
  timer_id = null
  _callFn = ->
    [pendings, works] = [null, pendings]
    timer_id = null
    try
      dcon.debug 'call squash'
      results = await opt.fn R.map R.prop('args'), works
      dcon.debug 'end call squash'
      for {resolve}, inx in works
        resolve results[inx]
    catch error
      for {reject}, inx in works
        reject error

  return (args...)-> new Promise (resolve, reject)->
    pendings ?= []
    pendings.push {resolve, reject, args}
    timer_id ?= setTimeout _callFn, opt.delay
    if pendings.length is opt.max
      clearTimeout timer_id
      _callFn()

byteToHexMap = [0..0xff].map (n)-> n.toString(16).padStart(2, "0");
dcon.debug 'byteToHexMap', byteToHexMap
bytes2Hex = (arrayBuffer)->
  buff = new Uint8Array(arrayBuffer);
  strs = Array.from(buff).map (v)-> byteToHexMap[v]
  strs = strs.join ''
  # if buff.length * 2 isnt strs.length
  #   console.error 'size not match.', strs, arrayBuffer, buff, buff.length, strs.length
  #   throw new Error 'Size Not Match?'
  return strs

hex2Bytes = (hex)=>
  toks = R.splitEvery 2, hex
  new Uint8Array toks.map (s)-> parseInt s, 16

removeWhitespace = (str)->
  str.replace /\s/g, ''


# dumpToJson = (obj)->
#   json = JSON.parse JSON.stringify obj
#   if R.is Error, obj
#     Object.assign json, {
#       message: obj.message
#       stack: obj.stack
#     }
#   return json

assignDeep = (dest, srcs...)->
  merged = R.reduce R.mergeDeepRight, dest, srcs
  Object.assign dest, merged
  return dest

updateDeep = (dest, data)->
  for own k, v of data
    continue unless dest.hasOwnProperty k
    console.log 'updateDeep', {k, v, data, dest}
    if R.is Array, v
      dest[k] = data[k]
    else if R.is Object, v
      updateDeep dest[k], data[k]
    else
      dest[k] = data[k]
  return dest

renameKeys = (obj, renamer)->
  v = R.values obj
  k = R.keys obj
  k = R.map renamer, k
  R.zipObj k, v

replaceDate = (json)->
  pathes = travel json, (k, v, pv)->
    R.endsWith '_datetime', k
  _asDate = (dt_str)->
    new Date dt_str
  for p in pathes
    [parent..., prop] = R.split '.', p
    container = R.path(parent, json)
    container[prop] = _asDate container[prop]
  return json


Object.assign exports, {
  bytes2Hex
  hex2Bytes
  removeWhitespace

  assignDeep
  updateDeep
  renameKeys
  replaceDate
  travel
  convert


  # dumpToJson
  parseBool
  # parseUPN
  # makeUPN

  # ensureByAjv
  # chErrMsg
  # nthCallStack

  squash
  retry
  postpone
  throwTimeoutAfter
  # catchErr

  # delay
  # delayMilSec
  # delaySec
  # willThrowTimeout
  Promise: props: PromiseProps

  waitOnce
  # constants: require './constants'
}
