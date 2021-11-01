dcon = require('deco-console')(__filename)
R = require 'ramda'
RA = require 'ramda-adjunct'

FE = require './conn-fe'
SV = require './conn-server'

console.log 'FE', FE

FE.on 'message', (data)->
  dcon.F.debug 'get msg from FE', data
  switch data.cmd
    when 'patreon-oauth'
      patreonOauth()
    when 'eval-item'
      SV.send data
    else
      dcon.error 'FE unhandled msg', data

SV.on 'message', (data)->
  dcon.F.debug 'get msg from SV', data
  switch data.cmd
    when 'eval-item'
      FE.send data
    # when 'crawl'
    #   craw = 1
    else
      dcon.error 'SV unhandled msg', data


{ clipboard } = require('electron')
PREV_TXT = ""
checkClipboard = ->
  text = clipboard.readText()
  return if PREV_TXT is text
  PREV_TXT = text
  return if not R.includes '--------', text
  dcon.F.debug 'send item', text
  FE.send {
    cmd: 'add-item', text
  }

setInterval checkClipboard, 300


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
patreonOauth = ->
  url = "https://patreon.com/oauth2/authorize?" + qs.stringify {
    response_type: 'code'
    client_id: PK_USING.clientId
    redirect_uri: PK_USING.redirect
  }
  open url
