R = require 'ramda'
RA = require 'ramda-adjunct'
J = require 'jsl'
dcon = require('deco-console')(__filename)


class Flow
  constructor: ->
    @_fns = []
    @_results = []
    @_ctx = {}
    @_err_become_return = false
    # @_protocol = 1 # 1은 ctx가 this, 2는 아규먼트 첫번쨰
  assignContext: (context)->
    Object.assign @_ctx, context
    return this
  errorBecomeReturn: (@_err_become_return = true)->
    return this
  go: (fn)->
    @_fns.push {go: fn}
    return this
  catchError: (fn)->
    @_fns.push {catchError: fn}
    return this
  anyway:(fn)->
    @_fns.push {anyway: fn}
    return this
  then: (resolve, reject)->
    try
      exit = false
      last_error = null
      for fn in @_fns
        {go, catchError, anyway} = fn
        if go?
          continue if exit
          continue if last_error?
          try
            await fn.go.call @_ctx
          catch error
            last_error = error
        if catchError?
          continue if exit
          continue unless last_error?
          ret = await fn.catchError.call @_ctx, last_error
          if ret is Flow.FAILOVER
            last_error = null
          else
            exit = true
            # throw last_error
        if anyway?
          try
            await fn.anyway.call @_ctx, last_error
          catch error
      if @_err_become_return is true
        return resolve last_error or null
      else if last_error?
        return reject last_error
      resolve null
    catch error
      reject error

Flow.FAILOVER = Symbol 'failover'

module.exports = Flow
