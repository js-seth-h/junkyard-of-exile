R = require 'ramda'
RA = require 'ramda-adjunct'
dcon = require('deco-console')(__filename)

bridge = require './bridge'
trader = require './trader'
PTF = require 'ptf3'

result = null
runsExampleCode = (text)->
  dcon.F.log 'runsExampleCode'
  result = PTF.parseItemText text
  dcon.log 'parsed PTF', R.clone result

  bridge.emit 'eval-item', PTF.forBackend result

bridge.on 'eval-result', (data)->
  dcon.F.log 'item evaluated', data

  PTF.applyEvaluate result, data
  dcon.F.log 'applyEvaluted', R.clone result
  trade_result = await trader.search result
  PTF.applyTradeResult result, trade_result



Object.assign exports, {
  runsExampleCode
}
