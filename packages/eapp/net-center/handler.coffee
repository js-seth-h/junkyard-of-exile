dcon = require('deco-console')(__filename)
R = require 'ramda'
RA = require 'ramda-adjunct'
J = require 'jsl'

FE = require './conn-fe'
SV = require './conn-server'
nanoid = require 'nanoid'


CTX = {}

catchErr = (fn)->
  return (args...)->
    try
      await fn args...
    catch error
      dcon.error error

{ clipboard } = require('electron')
checkClipboard = ->
  text = clipboard.readText()
  return if CTX.PREV_TXT is text
  CTX.PREV_TXT = text
  return if not R.includes '--------', text
  # dcon.F.debug 'send item', text
  FE.send {
    evt: 'add-item', text
  }

CTX.PREV_TXT = clipboard.readText()
setInterval checkClipboard, 300

CTX.TID_GMI = null

{MONO_REPO_DIR} = require('jsl/mono-repo')
nxJsonFs = require 'nx/jsonfile'
path = require 'path'
FE.on 'app-start', catchErr (data)->
  # _getMyId = ()-> SV.send {evt: 'get-my-id'}
  # CTX.TID_GMI = setInterval _getMyId, 2000
  # _getMyId()
  # [data] = await J.waitOnce SV, 'get-my-id'
  # clearInterval CTX.TID_GMI
  # CTX.MY_ID = data.client_id

  rule = await nxJsonFs.read path.join MONO_REPO_DIR, 'ref-data/metric-equip.json'
  # client_string = await nxJsonFs.read path.join MONO_REPO_DIR, 'ref-data/client-string.json'
  # item_classes = await nxJsonFs.read path.join MONO_REPO_DIR, 'ref-data/item-classes.json'
  BASETYPES = await nxJsonFs.read path.join MONO_REPO_DIR, 'ref-data/basetypes.json'
  KEYWORDS = await nxJsonFs.read path.join MONO_REPO_DIR, 'ref-data/keyword.json'
  MOD_WORDS = await nxJsonFs.read path.join MONO_REPO_DIR, 'ref-data/mod_words.json'

  ref_data = {MOD_WORDS, KEYWORDS, BASETYPES}
  FE.send {evt: 'app-ready', rule, ref_data }

FE.on 'eval-item', catchErr (data)->
  dcon.F.debug 'eval-item', data
  SV.send data
FE.on 'eval-ptf4', catchErr (data)->
  dcon.F.debug 'eval-ptf4', data
  SV.send data
SV.on 'eval-result', catchErr (data)->
  dcon.F.debug 'eval-result', data
  FE.send data

PK = {}
PK['REAL'] =
  # NOTE 절대 비밀 정보를 넣지 말것
  clientId: 'GNLVthqCf49GAa9jaDbGZioqk3xvz0QoAcPkWKR3WbI5087O1Um68INjPTLVd5kQ'
  redirect: 'http://54.151.203.228:5000/patreon/redirect'

PK['LOCAL_TEST'] =
  # NOTE 절대 비밀 정보를 넣지 말것
  clientId: 'GIS3fpyYIhh-CCQoXXV5pK5ZZBoZjLPmWPCN6pW7GUyNIJsYWVoG9X98QFMAj5Hp'
  redirect: 'http://localhost:5000/patreon/redirect'

env_set = process.env.PATREON
console.log 'env_set', env_set
PK_USING = PK[env_set or 'REAL']
qs = require 'qs'
open = require('open')

FE.on 'patreon-oauth', catchErr (data)->
  CTX.MY_ID = nanoid()
  dcon.F.debug 'I AM', CTX.MY_ID
  # while true
  #   SV.send {evt: 'I-am', client_id: CTX.MY_ID}
  #   [data] = await J.waitOnce SV, 'know-you'
  #   await J.postpone "100ms"

  url = "https://patreon.com/oauth2/authorize?" + qs.stringify {
    state: CTX.MY_ID
    response_type: 'code'
    client_id: PK_USING.clientId
    redirect_uri: PK_USING.redirect
  }
  console.log {url}
  open url
  while true
    await J.postpone "1sec"
    SV.send {evt: 'check-oauth', client_id: CTX.MY_ID}
    [data] = await J.waitOnce SV, 'check-oauth'
    break if data.ok
  FE.send {evt: 'oauth-login-ok'}

shutdown = ->
  SV.send {evt: 'shutdown', client_id: CTX.MY_ID}
  SV.send {evt: 'shutdown', client_id: CTX.MY_ID}

Object.assign exports, {
  shutdown
}
