// var PTF, R, RA, bridge, dcon, result, runsExampleCode, trader;
//
// R = require('ramda');
//
// RA = require('ramda-adjunct');
//
// dcon = require('deco-console')(__filename);
//
// bridge = require('./bridge');
//
// trader = require('./trader');
//
// PTF = require('ptf3');
//
// parsed_obj = null;
//
// runsExampleCode = function(poe_copied_text) {
//   dcon.F.log('runsExampleCode');
//   // # copy된 PoeText를 파서
//   parsed_obj = PTF.parseItemText(poe_copied_text);
//   dcon.log('parsed PTF', R.clone(parsed_obj));
//   // # 서버로 패킷을 만들어서 전송
//   return bridge.emit('eval-item', PTF.forBackend(parsed_obj));
// };
//
// bridge.on('eval-result', function(evaluate_result) {
//   // # 서버에서 아이템에 대한 평가 패킷이 도착하면 함수 호출됨
//   var trade_result;
//   dcon.F.log('item evaluated', evaluate_result);
//   // # 서버에서 반환된 평가 데이터(Rating)을 아이템 데이터에 반영
//   PTF.applyEvaluate(parsed_obj, evaluate_result);
//   dcon.F.log('applyEvaluted', R.clone(parsed_obj));
//
//   // # poe 거래소에서 검색
//   trade_result = await(trader.search(parsed_obj));
//   // # 거래소 검색 결과를 아이템에 반영
//   return PTF.applyTradeResult(parsed_obj, trade_result);
// });
//
// Object.assign(exports, {
//   runsExampleCode: runsExampleCode
// });
