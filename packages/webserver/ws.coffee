dcon = require('deco-console') __filename
R = require 'ramda'
RA = require 'ramda-adjunct'
J = require 'jsl'

handleFastify = (connection, req)->
  try
    await _handleFastify connection, req
  catch error
    console.error error

_handleFastify = (connection, req)->
  {socket} = connection
  # dcon.debug {connection}
  dcon.F.debug 'send init'

  socket.on 'message', (message)=>
    dcon.F.debug 'message?', message
  # socket.on 'open', ->
  # status_list = await LDM.status.fetchMany {}
  # work_logs = await LDM.work_log.fetchMany running: true

  socket.send JSON.stringify {
    # current: StatBoard.getCurrent()
    txt: "I am Server"
  }
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
}
