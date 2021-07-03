dcon = require('deco-console')(__filename)
R = require 'ramda'
RA = require 'ramda-adjunct'

# DynamicObj = ->
#   fn = (sch)->
#     sch.type ?= 'object'
#     sch.additionalProperties ?= true
#     if sch.nullable is true
#       sch.type = ['null', 'object']
#       delete sch.nullable
#     return sch
#   return fn

Any = ->
  fn = (sch)->
    sch.type = [
      'number', 'integer', 'string', 'boolean', 'array', 'object', 'null'
    ]
    return sch
  return fn

Obj = ->
  fn = (sch)->
    sch.type ?= 'object'
    sch.additionalProperties ?= false
    # dcon.debug {sch}
    # if fn._nullable
    #   sch.type = ['null', 'object']
    if sch.nullable is true
      sch.type = ['null', 'object']
      delete sch.nullable

    if sch.requiredProperties?
      throw new Error 'OLD SPEC'
    # sch.properties ?= {}
    if sch.properties?
      sch.required = R.keys sch.properties
    if sch.optionalProperties?
      sch.properties ?= {}
      Object.assign sch.properties, sch.optionalProperties
      delete sch.optionalProperties
    return sch
  return fn

List = ->
  fn = (sch)->
    sch.type ?= 'array'
    return sch
  return fn

Tuple = ->
  fn = (sch)->
    sch.type ?= 'array'
    sch.additionalItems = false
    return sch
  return fn

Object.assign exports, {
  Any
  Obj
  # DynamicObj
  List
  Tuple
}
