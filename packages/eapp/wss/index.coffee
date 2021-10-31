dcon = require('deco-console')(__filename)
R = require 'ramda'
RA = require 'ramda-adjunct'

path = require 'path'
{ clipboard } = require('electron')
shortid = require('shortid')
{ WebSocketServer } = require 'ws'
open = require('open')

G = {
  SERVER: null
  CLIENTS: []
}

# SERVER =
listen = (port)->
  G.SERVER = new WebSocketServer {port}
  G.SERVER.on 'connection', onConnect
  setInterval checkClipboard, 300

onConnect = (sock)->
  sock.id = shortid.generate()
  G.CLIENTS[sock.id] = sock
  dcon.info 'new ws', sock.id
  sock.on 'message', onMessage(sock)
  sock.on 'close', ->
    console.log 'closed socket', sock.id
    G.CLIENTS[sock.id] = null
  sock.send JSON.stringify {
    cmd: 'init'
    id: sock.id
    msg: 'Hi, FE websocket.'
  }

onMessage = R.curry (sock, json_str)->
  data = JSON.parse json_str
  console.log 'get ws msg', data
  if data.cmd is 'openUrl'
    open data.url
  else
    console.log 'ws unhandled msg', data, 'from', sock.id



PREV_TXT = ""
checkClipboard = ->
  text = clipboard.readText()
  return if PREV_TXT is text
  PREV_TXT = text
  return if not R.includes '--------', text

  for own sock_id, sock of G.CLIENTS
    try
      sock.send JSON.stringify {
        cmd: 'add-item', text
      }
    catch error
      dcon.error 'send add-item failed.', error

  # console.log "copyied text", {text}
  # EBUS.emit "poe-item-copied", text




Object.assign exports, {
  listen
}
