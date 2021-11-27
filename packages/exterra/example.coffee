# R = require 'ramda'
# RA = require 'ramda-adjunct'
# dcon = require('deco-console')(__filename)
#
# bridge = require './bridge'
# trader = require './trader'
# PTF = require 'ptf3'
#
# result = null
# runsExampleCode = (text)->
#   dcon.F.log 'runsExampleCode'
#   # copy된 PoeText를 파서
#   result = PTF.parseItemText text
#   dcon.log 'parsed PTF', R.clone result
#   # 서버로 패킷을 만들어서 전송
#   bridge.emit 'eval-item', PTF.forBackend result
#
# # 서버에서 아이템에 대한 평가 패킷이 도착하면 함수 호출됨
# bridge.on 'eval-result', (data)->
#   dcon.F.log 'item evaluated', data
#   # 서버에서 반환된 평가 데이터(Rating)을 아이템 데이터에 반영
#   PTF.applyEvaluate result, data
#   dcon.F.log 'applyEvaluted', R.clone result
#
#   # poe 거래소에서 검색
#   trade_result = await trader.search result
#   # 거래소 검색 결과를 아이템에 반영
#   PTF.applyTradeResult result, trade_result
#
#
#
# Object.assign exports, {
#   runsExampleCode
# }
