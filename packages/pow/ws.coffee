import store from './store'
R = require 'ramda'
RA = require 'ramda-adjunct'
dcon = require('deco-console')(__filename)

console.log 'ws aaa'
{hostname, port} = location
port = 8080
ws = new WebSocket "ws://#{hostname}:#{port}/ws"

ws.on = ws.addEventListener
ws.on 'open', ->
  console.log 'ws?????????'
  dcon.debug 'ws opend', arguments
  ws.send JSON.stringify {
    test: true
    hi: 'hi'
  }

ws.on 'message', (evt)->
  data = JSON.parse evt.data
  dcon.debug 'ws msg', data
  console.log('store', store)

#  alert data.text
#  ws.emit('MESSAGE', data)



  # if data.current?
  #   store.commit 'setAll', data.current
  # if data.status?
  #   store.commit 'updateStatus', data.status
  # # if data.work_logs?
  # #   store.commit 'setWorkLog', data.work_logs
  # if data.work_log?
  #   store.commit 'updateWorkLog', data.work_log
