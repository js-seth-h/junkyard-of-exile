FE = require './conn-fe'
SV = require './conn-server'
handler = require './handler'


SV_ADDR = process.env.SV_ADDR or '150.95.202.40'
init = ->
  await FE.config 8080
  await SV.config SV_ADDR, 5000


Object.assign exports, {
  init
  shutdown: handler.shutdown
}
