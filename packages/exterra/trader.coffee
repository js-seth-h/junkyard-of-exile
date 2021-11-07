R = require 'ramda'
RA = require 'ramda-adjunct'
dcon = require('deco-console')(__filename)

axios = require 'axios'
PTF3 = require 'ptf3'

search = (ptf_parsed)->
  postdata = PTF3.forTrade ptf_parsed

  url = 'https://poe.game.daum.net/api/trade/search/Scourge'
  res = await axios.post url, postdata # {"query":{"status":{"option":"any"},"stats":[{"type":"and","filters":[]}],"filters":{"type_filters":{"filters":{"rarity":{"option":"rare"}}}}},"sort":{"price":"asc"}}
  dcon.F.debug 'trade search', res
  {data} = res

  {id, result} = data
  dcon.F.debug result
  fetching = result[...10]
  dcon.F.debug {fetching}
  url = "https://poe.game.daum.net/api/trade/fetch/" + R.join ',', fetching
  res = await axios.get url, params: query: id
  dcon.F.debug 'trade fetch', res.data
  price = res.data.result[0].listing.price
  dcon.F.info 'min trade price ==',  "#{price.amount} #{price.currency}"
  return "#{price.amount} #{price.currency}"

Object.assign exports, {
  search
}
