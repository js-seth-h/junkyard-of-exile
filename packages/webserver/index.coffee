R = require 'ramda'
RA = require 'ramda-adjunct'
J = require 'jsl'
dcon = require('deco-console')(__filename)

http = require 'http'
dotenv = require 'dotenv'
dotenvExpand = require('dotenv-expand')


createServer = R.once ->
  CFG = require './cfg'
  FASTIFY = require './fastify'

  # address = await FASTIFY.listen port, process.env.PXC_SERVER_BIND_IP
  # dcon.info 'Web-Apis: open at', CFG.http_port, 'over', CFG.http_bind_ip
  addr = await FASTIFY.listen CFG.http_port
  dcon.info 'build server done'
  dcon.info '='.repeat 40
  dcon.info 'Web-Apis: open at', addr
  dcon.info 'build Server', 'OK'
  dcon.info '='.repeat 40


Object.assign exports, {
  createServer
}
