#!/usr/bin/env coffee
R = require 'ramda'
RA = require 'ramda-adjunct'
J = require 'jsl'
dcon = require('deco-console')(__filename) 
DCON_ENV = require('deco-console/env')

DCON_ENV.shorten (p)-> p.replace /.+packages\/(.+?)\//, ''
DCON_ENV.detail parseInt(process.env.DCON_VERBOSE) or 1
DCON_ENV.formatDatetime process.env.DCON_DT or 'T'

main = ->
  unless J.parseBool process.env.DISABLE_ENLIVEN
    unless process.env.ENLIVE_WATCHED
      host = require 'nx/enliven2/host'
      host.start =>
        child_p = require 'child_process'
        child_p.fork __filename, ['svr'],
          env: R.mergeRight process.env, ENLIVE_WATCHED: true
      return
    else
      delete process.env.ENLIVE_WATCHED
      child = require 'nx/enliven2/child'
      child.joinEnliven()

  # svr = require 'pxc/server'
  # await svr.createServer()
  webserver = require '../index'
  webserver.createServer()

main()
