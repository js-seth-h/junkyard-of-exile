R = require 'ramda'
RA = require 'ramda-adjunct'
J = require 'jsl'
dcon = require('deco-console')(__filename)

moment = require 'moment'
{expect} = require 'chai'
{GWT} = require 'gwt'

assert = require 'assert'


{Test} = require 'test-loop'

travel = require './travel'

new Test ->
  data =
    a: '1'

  pathes = travel data, (k, v)-> true

  expect(pathes).eql [ 'a' ]

new Test ->
  data =
    a: b: c: '1'

  cnt = 0
  orders = [ 'a', 'a.b', 'a.b.c' ]

  pathes = travel data, (k, v)->
    dcon.log [k, orders[cnt]]
    expect(k).eql orders[cnt++]
    true

  expect(pathes).eql orders

new Test ->
  data =
    a: b: c: '1'
  pathes = travel data, (k, v)-> v is '1'
  expect(pathes).eql ['a.b.c']

new Test ->
  data =
    a: b: c: '1'
  pathes = travel data, (k, v)-> R.endsWith '.b', k
  expect(pathes).eql ['a.b']

new Test ->
  data =
    a: [
      b: 1
    ,
      c: 2
      d: e: 2
    ,
      [1,2,3]
    ,
      f: [1,2]
    ]
  pathes = travel data, (k, v)->
    # console.log 'visitor', {k, v}
    true
  # console.log pathes
  expect(pathes).eql [
    'a',       'a.0',
    'a.0.b',   'a.1',
    'a.1.c',   'a.1.d',
    'a.1.d.e', 'a.2',
    'a.2.0',   'a.2.1',
    'a.2.2',   'a.3',
    'a.3.f',   'a.3.f.0',
    'a.3.f.1'
  ]
new Test ->
  data =
    a: [
      b: [1,2,3]
    ,
      c: 2
      d: e: 2
    ]
  pathes = travel data, (k, v, pv)->
    RA.isArray pv
  console.log pathes
  expect(pathes).eql [
    'a.0', 'a.0.b.0', 'a.0.b.1', 'a.0.b.2', 'a.1'
  ]
