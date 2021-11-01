#import app from './index'
R = require 'ramda'
RA = require 'ramda-adjunct'
dcon = require('deco-console')(__filename)

{hostname, port} = location
port = 8080
ws = new WebSocket "ws://#{hostname}:#{port}"

ws.on = ws.addEventListener
ws.on 'open', ->
  console.log 'ws?????????'
  dcon.debug 'ws opend', arguments
  # ws.send JSON.stringify {
  #   test: true
  #   hi: 'hi'
  # }

STORE = null
ws.on 'message', (evt)->
  data = JSON.parse evt.data
  # console.debug 'ws msg', data

  if data.cmd is 'add-item'
    STORE.dispatch('add_item', [data])
  else
    console.log 'ws unhandled msg', data

  # if data.current?
  #   store.commit 'setAll', data.current
  # if data.status?
  #   store.commit 'updateStatus', data.status
  # # if data.work_logs?
  # #   store.commit 'setWorkLog', data.work_logs
  # if data.work_log?
  #   store.commit 'updateWorkLog', data.work_log


openPatronOauth = (url)->
  ws.send JSON.stringify {
    cmd: 'patreon-oauth'
  }

setStore = (store)->
  STORE = store

evalItem = (data)->
  ws.send JSON.stringify {
    cmd: 'eval-item'
    data
  }
Object.assign exports, {
  setStore
  openPatronOauth
  evalItem
}
