R = require 'ramda'
RA = require 'ramda-adjunct'
J = require 'jsl'
dcon = require('deco-console')(__filename)

shortid = require('shortid')
EventEmitter = require('events');
EM = new EventEmitter()

{ WebSocketServer } = require 'ws'

G = {
  SERVER: null
  CLIENTS: {}
}

onConnect = (sock)->
  sock.id = shortid.generate()
  G.CLIENTS[sock.id] = sock
  dcon.info 'new ws', sock.id
  sock.on 'message', (msg)->
    json = JSON.parse msg
    dcon.F.debug 'sock on message', msg
    EM.emit json.evt, json
  sock.on 'close', ->
    console.log 'closed socket', sock.id
    G.CLIENTS[sock.id] = null
    delete G.CLIENTS[sock.id]
  EM.emit 'connection', sock

  send {
    cmd: 'init'
    id: sock.id
    msg: 'Hi, FE websocket.'
  }

send = (json)->
  for own key, sock of G.CLIENTS
    continue unless sock?
    try
      sock.send JSON.stringify json
    catch error
      console.warn error


config = (port)->
  G.SERVER = new WebSocketServer {port}
  G.SERVER.on 'connection', onConnect

Object.assign exports, {
  config
  send
  on: EM.on.bind(EM)
}
