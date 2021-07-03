dcon = require('deco-console') __filename
R = require 'ramda'
RA = require 'ramda-adjunct'
J = require 'jsl'

httpErrors = require 'http-errors'

moment = require 'moment'
mime = require 'mime'
path = require 'path'
fs = require 'mz/fs'

FASTIFY = require('fastify') {}
module.exports = FASTIFY

FASTIFY.decorateRequest 'pathname',
  getter: ->
    unless @_pathname?
      [@_pathname, queries] = R.split '?', @raw.url
    return @_pathname

FASTIFY.decorateRequest 'isApi',
  getter: ->
    @_is_api ?= R.startsWith '/api/', @pathname
    return @_is_api


FASTIFY.setNotFoundHandler (req, reply)->
  {pathname} = req
  dcon.debug 'NotFoundHandler', req.url
  # if R.startsWith '/api/', pathname
  if req.isApi
    return reply.send new httpErrors.NotFound

  # console.log 'pathname', pathname
  ext = path.extname(pathname)
  if ext isnt ''
    static_path = path.join process.env.MONO_REPO_DIR, 'webroot/pxc-wui', '.' + pathname
  else
    static_path = path.join process.env.MONO_REPO_DIR, 'webroot/pxc-wui', './index.html'
    ext = path.extname(static_path)
  unless await fs.exists static_path
    return reply.send new httpErrors.NotFound

  stat = await fs.stat(static_path)
  unless stat.isFile()
    return reply.send new httpErrors.NotFound

  reply.header 'Content-Type', mime.getType ext
  reply.header 'Content-Length', stat.size
  buf = await fs.readFile static_path
  return reply.send buf

FASTIFY.addHook 'preSerialization', (req, reply, payload, done)->
  if req.isApi is true
    unless payload.ok?
      newP = R.mergeRight payload, {ok: true, msg: 'ok'}
      # dcon.debug 'new payload', newP
      return done null, newP
  done null, payload

FASTIFY.setErrorHandler (error, req, reply)->
  if req.isApi is true
    dcon.debug 'fastify send error', error
    reply.statusCode = 200 # if reply.statusCode is 500
    return reply.send {
      ok:false, msg: error.message
      rethrow_error: error.toJSON()
    }

  unless error.statusCode?
    error = new httpErrors.BadRequest()
  reply.statusCode = error.statusCode
  reply.send error.message
