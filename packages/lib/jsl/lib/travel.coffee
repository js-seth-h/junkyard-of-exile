R = require 'ramda'
RA = require 'ramda-adjunct'
dcon = require('deco-console')(__filename)

travelObj = (parent, data, visitor)->
  pathes = []
  for own k, v of data
    dot_path = parent + k
    if visitor.call {context: data }, dot_path, v
      pathes.push dot_path
    if RA.isPlainObj v
      list = travelObj dot_path + '.', v, visitor
      pathes.push list...
    if RA.isArray v
      list = travelArr dot_path + '.', v, visitor
      pathes.push list...
  return pathes

travelArr = (parent, data, visitor)->
  pathes = []
  for v, inx in data
    dot_path = parent + inx
    if visitor.call {context: data }, dot_path, v
      pathes.push dot_path
    if RA.isPlainObj v
      list = travelObj dot_path + '.', v, visitor
      pathes.push list...
    if RA.isArray v
      list = travelArr dot_path + '.', v, visitor
      pathes.push list...
  return pathes

travel = (data, visitor)->
  if RA.isPlainObj data
    return travelObj '', data, visitor
  if RA.isArray data
    return travelArr '', data, visitor
  throw new Error 'Unspecific Error'

module.exports = travel
