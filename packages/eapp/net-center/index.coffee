FE = require './conn-fe'
SV = require './conn-server'
handler = require './handler'

init = ->
  await FE.config 8080
  await SV.config 'wiki.cmgom.com', 5000


Object.assign exports, {
  init
  shutdown: handler.shutdown
}
