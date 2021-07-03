R = require 'ramda'
RA = require 'ramda-adjunct'
J = require 'jsl'
dcon = require('deco-console')(__filename)

jwtDecode = require 'jwt-decode'
AXIOS = require 'axios'
qs = require 'qs'

# NOTE ISO 5,6 계층 - 세션, 데이터 표현
# JSON의 표현능력이 한계가 있음으로 형처리 등도 커스텀하게 지원할것.


# ok = (payload)->
#   Object.assign payload, {
#     ok: true
#     msg: 'ok'
#   }
#   dcon.debug 'ok', {payload}
#   return payload


paramsSerializer = (params)->
  qs.stringify params, allowDots: true

transformResponse = (res_body)->
  json = JSON.parse res_body
  json = J.replaceDate json
  return rethrowIfError json

rethrowIfError = (json)->
  if json.ok isnt true
    if json.rethrow_error?
      dcon.debug 'rethrowIfError', json
      e = Error.fromJSON json.rethrow_error
      # e = new Error "Rethrowed Error."
      # Object.assign e, json.rethrow_error
    else
      e = new Error json.msg
      dcon.debug 'rethrow msg', json, e
    throw e
  return json


createAxios = ()->
  axios = AXIOS.create {
    paramsSerializer
    transformResponse
  }
  addApiIoFns axios
  return axios

addApiIoFns = (axios)->
  CURRENT_JWT = null
  setAuth = (token)->
    dcon.debug 'setAuth', token
    if token?
      CURRENT_JWT = token
      axios.defaults.headers.common['Authorization'] = 'Bearer ' + token
    else
      CURRENT_JWT = null
      axios.defaults.headers.common['Authorization'] = undefined
    # remember token

  hasAuth = ()->
    return false unless CURRENT_JWT?
    data = jwtDecode CURRENT_JWT
    dcon.debug 'hasAuth?', data
    return true

  getRemainTime = ->
    return 0 unless CURRENT_JWT
    data = jwtDecode CURRENT_JWT
    dcon.debug 'jwtDecode', data
    return data.exp - (new Date).getTime()

  getAuthData = (dot_path)->
    unless CURRENT_JWT
      throw new Error '[EPXC-002] Not Logined'
    data = jwtDecode CURRENT_JWT
    unless dot_path
      return data

    dcon.debug 'data', data
    pp = R.split('.', dot_path)
    unless R.hasPath pp, data
      throw new Error '[ECMN-000] Unspecified Access'
    return R.path pp, data


  Object.assign axios, {
    setAuth
    hasAuth
    getRemainTime
    getAuthData

    # getLoginProtocol2
  }


Object.assign exports, {
  # # recoveryAuth
  # setAuth
  # hasAuth
  # getRemainTime
  # getAuthData
  # rethrowIfError
  createAxios

}
