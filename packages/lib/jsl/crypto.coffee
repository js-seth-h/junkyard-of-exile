R = require 'ramda'
RA = require 'ramda-adjunct'
J = require 'jsl'
dcon = require('deco-console')(__filename)

FG = require 'node-forge'
# dcon = console

ITER_SCALE = 5000
PASS_LEN = 256
getSaltIter = (login_id, login_pwd )->
  salt_seed = R.join '', R.flatten R.zip login_id + login_pwd, login_pwd + login_id

  md = FG.md.sha512.create();
  md.update salt_seed
  salt = md.digest().toHex()
  # msgUint8 = new TextEncoder().encode(salt_seed)
  # hashBuffer = await crypto.subtle.digest('SHA-256', msgUint8)
  # salt = J.bytes2Hex hashBuffer
  iter = ITER_SCALE + parseInt(salt[...4], 16) % ITER_SCALE
  return {salt, iter}

deriveLogin = (login_id, login_pwd)->
  {salt, iter} = getSaltIter login_id, login_pwd
  dcon.debug {salt, iter}
  # dcon.debug 'salt hex =', salt.toHex()
  # dcon.debug 'bytes', str: salt.getBytes()
  # dcon.debug salt.getBytes().charCodeAt(1)

  # buffer = FG.util.createBuffer(login_pwd, 'utf8');
  # dcon.debug 'buffer=', buffer
  derived_pwd = FG.pkcs5.pbkdf2(login_pwd, salt, iter, 256, 'sha512');
  derived_pwd = FG.util.bytesToHex derived_pwd
  dcon.debug 'derived_pwd', derived_pwd
  return {login_id, derived_pwd}


encryptJSON = (secret_hex, obj)->
  data = JSON.stringify obj
  secret_key = FG.util.hexToBytes J.removeWhitespace secret_hex
  iv = FG.random.getBytesSync 16
  data_buf = FG.util.createBuffer data, 'utf8'

  dcon.debug {iv, secret_key, data}
  dcon.debug 'data_buf=', data_buf.toHex()

  cipher = FG.cipher.createCipher('AES-CBC', secret_key);
  cipher.start {iv}
  cipher.update data_buf
  cipher.finish()

  enc_hex = cipher.output.toHex()
  dcon.debug 'cipher.output', cipher.output
  dcon.debug 'enc_hex', enc_hex
  iv_hex = FG.util.bytesToHex iv
  dcon.debug 'iv', iv_hex, iv_hex.length
  enc_data = R.join '.', [iv_hex, enc_hex]

# crypto = require 'crypto'
# decrypt = (secret_hex, data_hex)->
#   [iv, data ] = R.split '.', data_hex
#   iv = Buffer.from iv, 'hex'
#   secret_key = Buffer.from J.removeWhitespace(secret_hex), 'hex'
#   dcon.debug 'iv, data', {iv, data, secret_key}
#   dechiper = crypto.createDecipheriv 'aes-256-cbc', secret_key, iv
#   str = dechiper.update data, 'hex', 'utf8'
#   str += dechiper.final 'utf8'
#   dcon.debug 'dechiper', str, '<<', data_hex
#   data = JSON.parse str

decryptJSON = (secret_hex, data_hex)->
  [iv_hex, enc_hex ] = R.split '.', data_hex
  dcon.debug 'iv_hex, enc_hex', {iv_hex, enc_hex}
  secret_key = FG.util.hexToBytes J.removeWhitespace secret_hex
  iv = FG.util.hexToBytes iv_hex
  buf = FG.util.createBuffer FG.util.hexToBytes enc_hex
  dcon.debug {iv, secret_key, buf}

  decipher = FG.cipher.createDecipher('AES-CBC', secret_key);
  decipher.start {iv}
  decipher.update buf
  result = decipher.finish();
  dcon.debug {result}
  str = decipher.output.toString()
  return JSON.parse str

  # console.log(decipher.output);
# SECRET_KEY = '20212223 24252627 28292a2b 2c2d2e2f 20212223 24252627 28292a2b 2c2d2e2f'
# dcon.log decrypt SECRET_KEY, encrypt SECRET_KEY, {test: 1, a:2, b: 3}


md5JSON = (obj)->
  d = FG.md.md5.create()
  d.update(JSON.stringify obj)
  d.digest().toHex()

Object.assign exports, {
  deriveLogin
  encryptJSON
  decryptJSON
  md5JSON
}
