R = require 'ramda'
RA = require 'ramda-adjunct'
J = require 'jsl'
dcon = require('deco-console')(__filename)

path = require 'path'
nxJson = require 'nx/jsonfile'
fs = require 'mz/fs'

tf = require '@tensorflow/tfjs-node'

encode = (item_str)->
  blocks = R.map R.trim, R.split '--------', item_str
  blocks = R.map R.split('\n'), blocks
  # blocks = R.map R.map(R.split(":")), blocks
  # console.log {__dirname}
  # console.log path.join __dirname, './refdata-ai/base_items.kr.json'
  base_items = await nxJson.read path.join __dirname, './refdata-ai/base_items.kr.json'
  base_item = base_items[blocks[0][3]]
  {item_type} = base_item

  TRANS = JSON.parse await fs.readFile path.join __dirname, "./refdata-ai/#{item_type}.translate.json"
  Pattern = R.map R.prop('kr'), TRANS
  re_list = Pattern.map (str)->
    str = str.replace /#/gm, "([+-\d]+)"
    # console.log 'str', str
    new RegExp '^' + str + '$', 'gm'

  # console.log blocks

  _asCode = (mod)->
    for re, inx in re_list
      is_match = mod.match re
      if is_match?
        # console.log inx, is_match, mod, re
        return inx
    return null
  code = RA.compact R.map _asCode, R.flatten blocks

  txts = code.map (inx)-> Pattern[inx]

  fn = "file://./tensorflow/#{item_type}/model.json"
  model = await tf.loadLayersModel fn

  input = new Array(Pattern.length)
  input.fill 0
  for i in code
    input[i] = 1
  xs = tf.tensor1d input

  r = model.predict tf.stack [xs]
  v = Array.from r.dataSync()

  # rating_sum = R.sum v
  # rating_mean = R.mean v
  # rating_sd = standard_deviation v
  # criteria = rating_mean + rating_sd

  criteria = 0.02
  SKILLS = JSON.parse await fs.readFile "./poedb/skills.json"
  skill_krs = R.map R.prop('name_kr'), SKILLS
  rating = zipIV skill_krs, v
  rating = R.reverse R.sortBy R.prop('value'), rating
  # console.log {criteria}
  recommand = R.filter R.o(R.lte(criteria), R.prop('value')), rating

  console.log {base_item, blocks, code, txts, recommand}

variance = (X)=>
  square_error = R.compose(
    R.partialRight(Math.pow, [2]),
    R.subtract(R.__, R.mean(X)),
  )
  return R.compose(R.mean, R.map(square_error))(X)
standard_deviation = R.compose(Math.sqrt, variance)

zipIV = R.zipWith (name, value)-> {name, value}


item_strs = [
  """
  아이템 종류: 방패
  아이템 희귀도: 희귀
  야수의 발
  금색 버클러
  --------
  막기 확률: 25%
  회피: 409 (augmented)
  --------
  요구사항:
  레벨: 54
  민첩: 130
  --------
  홈: G G
  --------
  아이템 레벨: 56
  --------
  이동 속도 6% 증가 (implicit)
  --------
  회피 32% 증가
  생명력 최대치 +51
  화염 저항 +18%
  냉기 저항 +34%
  --------
  메모: ~price 1 silver
  """
  """
  아이템 종류: 양손 철퇴
  아이템 희귀도: 희귀
  악마 폭발
  카루이 대형 망치
  --------
  양손 철퇴
  퀄리티: +16% (augmented)
  물리 피해: 151-227 (augmented)
  치명타 확률: 6.40% (augmented)
  초당 공격 횟수: 1.00
  무기 범위: 13
  --------
  요구사항:
  레벨: 57
  힘: 182
  --------
  홈: R-R
  --------
  아이템 레벨: 70
  --------
  적에게 적용되는 기절 지속시간 45% 증가 (implicit)
  --------
  힘 +30
  물리 피해 18~28 추가
  치명타 확률 28% 증가
  번개 저항 +17%
  퀄리티 +16%
  --------
  메모: ~price 1 chrome
  """
  """
  아이템 종류: 갑옷
  아이템 희귀도: 희귀
  휴거 껍질
  장어가죽 튜닉
  --------
  회피: 804 (augmented)
  --------
  요구사항:
  레벨: 56
  민첩: 104
  --------
  홈: B-G B G
  --------
  아이템 레벨: 72
  --------
  민첩 +32
  회피 +431
  생명력 최대치 +92
  번개 저항 +12%
  카오스 저항 +29%
  --------
  타락
  --------
  메모: ~price 1 chrome
  """
  # """
  # 아이템 종류: 주얼
  # 아이템 희귀도: 희귀
  # 마엘스트롬 지복
  # 코발트색 주얼
  # --------
  # 아이템 레벨: 70
  # --------
  # 지속 냉기 피해 배율 +3%
  # 마나 재생 속도 15% 증가
  # 냉기 및 번개 저항 +12%
  # --------
  # 패시브 스킬 트리에서 포인트를 할당한 주얼 슬롯에 장착하십시오. 우클릭하면 슬롯에서 제거됩니다.
  # """
  # """
  # 아이템 종류: 주얼
  # 아이템 희귀도: 희귀
  # 불사조 심장
  # 대형 스킬 군 주얼
  # --------
  # 아이템 레벨: 45
  # --------
  # 패시브 스킬 9개 추가 (enchant)
  # 주얼 슬롯 패시브 스킬 2개 추가 (enchant)
  # 추가된 소형 패시브 스킬 효과: 클로 공격으로 주는 적중 및 상태 이상 피해 12% 증가 (enchant)
  # 추가된 소형 패시브 스킬 효과: 단검 공격으로 주는 적중 및 상태 이상 피해 12% 증가 (enchant)
  # --------
  # 추가되는 소형 패시브 스킬이 카오스 저항 +3% 부여
  # 추가되는 소형 패시브 스킬이 최대 생명력 +3 부여
  # 전투 장려 패시브 스킬 1개 추가
  # --------
  # 패시브 스킬 트리에서 포인트를 할당한 대형 주얼 슬롯에 장착하십시오. 추가된 패시브 스킬은 주얼 반경과 상호작용하지 않습니다. 우클릭하면 슬롯에서 제거됩니다.
  # """
]

for s in item_strs
  encode s

Object.assign exports, {
  encode
}
