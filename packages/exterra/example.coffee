R = require 'ramda'
RA = require 'ramda-adjunct'
dcon = require('deco-console')(__filename)

bridge = require './bridge'
trader = require './trader'
PTF = require 'ptf3'

runsExampleCode = (text)->
  result = PTF.parseItemText text
  dcon.log 'parsed PTF', result

  bridge.emit 'eval-item', PTF.forBackend result
  # postdata = PTF.forTrade result

  # dcon.F.debug 'for Trader', postdata
  await trader.search result

bridge.on 'eval-result', (data)->
  dcon.F.debug 'item evaluated', data


Object.assign exports, {
  runsExampleCode
}
