R = require 'ramda'
RA = require 'ramda-adjunct'
dcon = require('deco-console')(__filename)

axios = require 'axios'
PTF = require 'ptf4'

search = (ptf_parsed)->
  postdata = PTF.forTrade ptf_parsed
  return null unless postdata
  dcon.F.debug 'search', postdata
  url = 'https://poe.game.daum.net/api/trade/search/Sentinel'
  res = await axios.post url, postdata # {"query":{"status":{"option":"any"},"stats":[{"type":"and","filters":[]}],"filters":{"type_filters":{"filters":{"rarity":{"option":"rare"}}}}},"sort":{"price":"asc"}}
  dcon.F.debug 'trade search', R.pick [
    'data','status', 'statusText', 'headers', 'config'
    ], res
  {data} = res
  dcon.F.debug data

  {id, result} = data
  dcon.F.debug 'POE ITEM TRADE URL =', "https://poe.game.daum.net/trade/search/Scourge/#{id}"
  dcon.F.debug result
  fetching = result[...10]
  dcon.F.debug {fetching}

  if fetching.length > 0
    url = "https://poe.game.daum.net/api/trade/fetch/" + R.join ',', fetching
    res = await axios.get url, params: query: id
    # dcon.F.debug 'trade fetch', res.data
    price = res.data.result[0].listing.price
    dcon.F.info 'min trade price ==',  "#{price.amount} #{price.currency}"
    return "#{price.amount} #{price.currency}"


Object.assign exports, {
  search
}
