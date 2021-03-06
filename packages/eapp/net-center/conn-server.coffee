R = require 'ramda'
RA = require 'ramda-adjunct'
J = require 'jsl'
dcon = require('deco-console')(__filename)

dgram = require('dgram');
sock = dgram.createSocket('udp4');

EventEmitter = require('events');
EM = new EventEmitter()
module.exports = exports = EM

SERVER_ADRR = {}


sock.on 'message', (buf)->
  json = JSON.parse buf
  dcon.F.debug 'get msg', json
  EM.emit json.evt, json

send = (json)->
  str = JSON.stringify json
  dcon.F.debug 'SV send to', SERVER_ADRR
  sock.send str, SERVER_ADRR.port, SERVER_ADRR.address

config = (address, port)->
  Object.assign SERVER_ADRR, {address, port}
  dcon.info 'set SERVER_ADRR', SERVER_ADRR
  sock.bind()

Object.assign exports, {
  config
  send
}
