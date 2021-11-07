R = require 'ramda'
RA = require 'ramda-adjunct'
dcon = require('deco-console')(__filename)

bridge = require './bridge'
trader = require './trader'
PTF3 = require 'ptf3'

runsExampleCode = (text)->
  result = PTF3.parseItemText text
  dcon.log 'parsed PTF3', result

  bridge.emit 'eval-item', PTF3.forBackend result
  postdata = PTF3.forTrade result

  dcon.F.debug 'for Trader', postdata
  await trader.search postdata

bridge.on 'eval-result', (data)->
  dcon.F.debug 'item evaluated', data


Object.assign exports, {
  runsExampleCode
}
