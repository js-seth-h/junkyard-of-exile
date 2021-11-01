R = require 'ramda'
RA = require 'ramda-adjunct'
dcon = require('deco-console')(__filename)

qs = require('qs')

PK = {}
PK['REAL'] =
  # NOTE 절대 비밀 정보를 넣지 말것
  clientId: 'GNLVthqCf49GAa9jaDbGZioqk3xvz0QoAcPkWKR3WbI5087O1Um68INjPTLVd5kQ'
  redirect: 'http://wiki.cmgom.com:5000/patreon/redirect'
  ws_addr: "ws://wiki.cmgom.com:5000/ws"

PK['LOCAL_TEST'] =
  # NOTE 절대 비밀 정보를 넣지 말것
  clientId: 'GIS3fpyYIhh-CCQoXXV5pK5ZZBoZjLPmWPCN6pW7GUyNIJsYWVoG9X98QFMAj5Hp'
  redirect: 'http://localhost:5000/patreon/redirect'
  ws_addr: "ws://localhost:5000/ws"

env_set = process.env.PATREON
console.log 'env_set', env_set
PK_USING = PK[env_set or 'REAL']

CTX = {}

initialized = new Promise (done)->
  CTX.ws = ws = new WebSocket PK_USING.ws_addr
  ws.on = ws.addEventListener
  ws.on 'open', ()-> console.log 'backend opend'
  ws.on 'message', (evt)->
    data = JSON.parse evt.data
    if data.cmd is 'init'
      CTX.ID = data.id
      console.log 'connect to backend'
      done null

getPatreonOauthUrl = ->
  unless CTX.ID?
    throw new Error 'backend-connection NOT ready.'

  url = "https://patreon.com/oauth2/authorize?" + qs.stringify {
    response_type: 'code'
    client_id: PK_USING.clientId
    redirect_uri: PK_USING.redirect
    state: CTX.ID
  }

ready = ->
  await initialized

Object.assign exports, {
  ready
  getPatreonOauthUrl
}
