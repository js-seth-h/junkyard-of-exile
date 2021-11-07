

axios = require 'axios'


search = ->
  url = 'https://poe.game.daum.net/api/trade/search/Scourge'
  res = await axios.post url, {"query":{"status":{"option":"any"},"stats":[{"type":"and","filters":[]}],"filters":{"type_filters":{"filters":{"rarity":{"option":"rare"}}}}},"sort":{"price":"asc"}}
