#import app from './index'
R = require 'ramda'
RA = require 'ramda-adjunct'
dcon = require('deco-console')(__filename)

{hostname, port} = location
port = 8080

EventEmitter = require('events');
EVT_BUS = new EventEmitter()
module.exports = exports = EVT_BUS

J = require 'jsl'

ws = new WebSocket "ws://#{hostname}:#{port}"


ws.on = ws.addEventListener
isReady = J.waitOnce ws, 'open'

ws.on 'open', ->
  console.log 'ws?????????'
  dcon.debug 'ws opend', arguments

STORE = null
ws.on 'message', (msg_event)->
  data = JSON.parse msg_event.data
  # console.debug 'ws msg', data
  EVT_BUS.emit data.evt, data

  # if data.cmd is 'add-item'
  #   STORE.dispatch('add_item', [data])
  # else
  #   console.log 'ws unhandled msg', data

sendJSON = (json)->
  ws.send JSON.stringify json

appStart = ()-> sendJSON {evt: 'app-start'}
openPatronOauth = (url)->
  sendJSON { evt: 'patreon-oauth' }
#
# setStore = (store)->
#   STORE = store

evalItem = (item)->
  sendJSON { evt: 'eval-item', item }

Object.assign exports, {
  isReady
  # setStore
  sendJSON
  appStart
  openPatronOauth
  evalItem
}
