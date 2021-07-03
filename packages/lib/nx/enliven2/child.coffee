R = require 'ramda'
RA = require 'ramda-adjunct'
dcon = require('deco-console')(__filename)
J = require 'jsl'

dgram = require('dgram')

joinEnliven = ->
  unless process.env.HMR_HOSTED_PORT?
    return
    # throw new Error 'HMR host not found'

  client = dgram.createSocket('udp4')
  await new Promise (done)->
    client.bind 0, '127.0.0.1', done
  # client.bind 0
  dcon.info process.pid, 'support enliven', client.address()

  port = parseInt process.env.HMR_HOSTED_PORT
  m = require 'module'
  modules = R.uniq R.values(m._pathCache)
  modules = R.reject R.includes('node_modules'), modules
  # tid = setTimeout _reportDeps, 50
  msg = 'SET-PORT ' + client.address().port
  client.send msg, port
  client.on 'message', (msg)->
    if msg.toString() is 'die-for-enliven'
      process.exit(77)

  for filepath in modules
    # dcon.info process.pid, 'udp put', filepath
    client.send filepath, port

  orig_load = m.prototype.load
  m.prototype.load = (filepath)->
    if not R.includes 'node_modules', filepath
      # console.info 'snap', filepath
      client.send filepath, port
    orig_load.call this, filepath

Object.assign exports, {
  joinEnliven
}
