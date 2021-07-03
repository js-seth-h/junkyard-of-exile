R = require 'ramda'
RA = require 'ramda-adjunct'
dcon = require('deco-console')(__filename)

joinPath = (p, c)->
  if p isnt ''
    return p + '.' + c
  return c

convertObj = (parent, obj, visitor)->
  result = {}
  for own key, value of obj
    path = joinPath(parent, key)
    if RA.isPlainObj value
      value = convertObj path, value, visitor
    else if RA.isArray value
      value = convertArr path, value, visitor
    { key, value } = visitor {
      type: 'object', key, path, value
    }
    result[key] = value
  return result

convertArr = (parent, arr, visitor)->
  result = []
  for value, inx in arr
    path = joinPath(parent, inx)
    if RA.isPlainObj value
      value = convertObj path, value, visitor
    if RA.isArray value
      value = convertArr path, value, visitor
    {value } = visitor {
      type: 'array', inx, path, value
    }
    result[inx] = value 

convert = (data, visitor)->
  if RA.isPlainObj data
    return convertObj '', data, visitor
  if RA.isArray data
    return convertArr '', data, visitor
  throw new Error 'Unspecific Error'

module.exports = convert
