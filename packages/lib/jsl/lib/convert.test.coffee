R = require 'ramda'
RA = require 'ramda-adjunct'
J = require 'jsl'
dcon = require('deco-console')(__filename)

moment = require 'moment'
{expect} = require 'chai'

convert = require './convert'

data =
  a: [
    b: [1,2,3]
  ,
    c: 2
    d: $e: 2
  ]
obj = convert data, (node)->
  if node.key is '$e'
    node.key = '__$e'
  return node

console.log JSON.stringify data, null, 2
console.log '>>>>>>>>>>>>>>>'
console.log JSON.stringify obj, null, 2
