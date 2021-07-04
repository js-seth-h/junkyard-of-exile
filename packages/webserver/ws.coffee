dcon = require('deco-console') __filename
R = require 'ramda'
RA = require 'ramda-adjunct'
J = require 'jsl'
shortid = require('shortid')

SOCKETS = {}
ITEMS = []
addItem = (text)->
  item_id = shortid.generate()
  item = {item_id, text}
  ITEMS.push item
  flushItem item

flushItem = (item)->
  for own k, socket of SOCKETS
    socket.send JSON.stringify item

handleFastify = (connection, req)->
  try
    await _handleFastify connection, req
  catch error
    console.error error

_handleFastify = (connection, req)->
  sock_id = shortid.generate()
  {socket} = connection
  # dcon.debug {connection}
  dcon.F.debug 'send init'
  SOCKETS[sock_id] = socket
  ws.on 'close', ->
    SOCKETS[sock_id] = null
  for item in ITEMS
    socket.send JSON.stringify item
  socket.on 'message', (message)=>
    dcon.F.debug 'message?', message
  # socket.on 'open', ->
  # status_list = await LDM.status.fetchMany {}
  # work_logs = await LDM.work_log.fetchMany running: true
  #
  # socket.send JSON.stringify {
  #   # current: StatBoard.getCurrent()
  #   txt: "I am Server"
  # }
  #
  # StatBoard.on 'worklogue-changed', (doc)->
  #   dcon.debug 'send to ws'
  #   socket.send JSON.stringify {
  #     work_log: doc
  #   }
  #
  # StatBoard.on 'status-changed', (doc)->
  #   socket.send JSON.stringify {
  #     status: doc
  #   }

Object.assign exports, {
  handleFastify
  addItem
}
