dcon = require('deco-console')(__filename)
R = require 'ramda'
RA = require 'ramda-adjunct'

FE = require './conn-fe'
SV = require './conn-server'

import once from '@tootallnate/once'
# once = require '@tootallnate/once'

CTX = {}

# console.log 'FE', FE

# FE.on 'message', (data)->
#   dcon.F.debug 'get msg from FE', data
#   switch data.evt
#     when 'start-app'
#       startApp()
#     when 'patreon-oauth'
#       unless MY_ID?
#         FE.send {evt: 'error', message: 'E-0001. App can not connect to server.' }
#         return
#       patreonOauth()
#     when 'eval-item'
#       SV.send data
#     else
#       dcon.error 'FE unhandled msg', data
#
#
# SV.on 'message', (data)->
#   dcon.F.debug 'get msg from SV', data
#   switch data.evt
#     # when 'get-my-id'
#     #   MY_ID = data.client_id
#     #   clearInterval TID_GMI
#     #   TID_GMI = null
#     when 'eval-item'
#       FE.send data
#     # when 'crawl'
#     #   craw = 1
#     else
#       dcon.error 'SV unhandled msg', data
#

{ clipboard } = require('electron')
checkClipboard = ->
  text = clipboard.readText()
  return if CTX.PREV_TXT is text
  CTX.PREV_TXT = text
  return if not R.includes '--------', text
  dcon.F.debug 'send item', text
  FE.send {
    evt: 'add-item', text
  }

CTX.TID_GMI = null

FE.on 'app-start', (data)->
  _getMyId = ()-> SV.send {evt: 'get-my-id'}
  CTX.TID_GMI = setInterval _getMyId, 2000
  _getMyId()
  [data] = await once SV, 'get-my-id'
  clearInterval CTX.TID_GMI
  CTX.MY_ID = data.client_id

  CTX.PREV_TXT = clipboard.readText()
  setInterval checkClipboard, 300

  FE.send {evt: 'app-ready'}


PK = {}
PK['REAL'] =
  # NOTE 절대 비밀 정보를 넣지 말것
  clientId: 'GNLVthqCf49GAa9jaDbGZioqk3xvz0QoAcPkWKR3WbI5087O1Um68INjPTLVd5kQ'
  redirect: 'http://wiki.cmgom.com:5000/patreon/redirect'

PK['LOCAL_TEST'] =
  # NOTE 절대 비밀 정보를 넣지 말것
  clientId: 'GIS3fpyYIhh-CCQoXXV5pK5ZZBoZjLPmWPCN6pW7GUyNIJsYWVoG9X98QFMAj5Hp'
  redirect: 'http://localhost:5000/patreon/redirect'

env_set = process.env.PATREON
console.log 'env_set', env_set
PK_USING = PK[env_set or 'REAL']
qs = require 'qs'
open = require('open')

FE.on 'patreon-oauth', (data)->
  url = "https://patreon.com/oauth2/authorize?" + qs.stringify {
    response_type: 'code'
    client_id: PK_USING.clientId
    redirect_uri: PK_USING.redirect
    state: CTX.MY_ID
  }
  open url
  [data] = await once SV, 'oauth-login-ok'
  FE.send {evt: 'oauth-login-ok'}
