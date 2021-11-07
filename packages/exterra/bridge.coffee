R = require 'ramda'
RA = require 'ramda-adjunct'
dcon = require('deco-console')(__filename)

J = require 'jsl'
ws = new WebSocket "ws://localhost:8080"
isReady = J.waitOnce ws, 'open'


emit = (evt, data)->
  json = R.mergeRight {evt}, data
  ws.send JSON.stringify json

ws.addEventListener 'open', ->
  dcon.info 'electron bridge opend'

ws.addEventListener 'message', (msg_event)->
  try
    data = JSON.parse msg_event.data
    console.debug 'ws msg', data
    OUT_BUS.emit data.evt, data
  catch error
    console.error error 


EventEmitter = require('events');
OUT_BUS = new EventEmitter()
addListener = OUT_BUS.addListener.bind(OUT_BUS)
removeListener = OUT_BUS.removeListener.bind(OUT_BUS)
Object.assign exports, {
  isReady
  emit
  on: addListener, addListener
  off: removeListener, removeListener
}
