R = require 'ramda'
RA = require 'ramda-adjunct'
J = require 'jsl'
dcon = require('deco-console')(__filename)

dgram = require('dgram');
sock = dgram.createSocket('udp4');

EventEmitter = require('events');

EM = new EventEmitter()

SERVER_ADRR = {}


sock.on 'message', (buf)->
  json = JSON.parse buf
  EM.emit json.evt, json

send = (json)->
  str = JSON.stringify json
  sock.send str, SERVER_ADRR.port, SERVER_ADRR.address

config = (address, port)->
  Object.assign SERVER_ADRR, {address, port}
  sock.bind()

Object.assign exports, {
  config
  send
  on: EM.on.bind(EM)
}
