R = require 'ramda'
RA = require 'ramda-adjunct'
dcon = require('deco-console')(__filename)

fs = require 'mz/fs'
mkdirp = require 'mkdirp'
path = require 'path'


readSync = (filepath)->
  unless fs.existsSync filepath
    throw new Error 'File not found'
  rawdata = fs.readFileSync filepath
  return JSON.parse rawdata

writeSync = (filepath, json, replacer = undefined, spacer = undefined)->
  str = JSON.stringify json, replacer, spacer
  # console.log 'writeJSON', str, 'from', json
  mkdirp.sync path.dirname filepath
  fs.writeFileSync filepath, str


read = (filepath)->
  unless await fs.exists filepath
    throw new Error 'File not found'
  rawdata = await fs.readFile filepath
  return JSON.parse rawdata

write = (filepath, json, replacer = undefined, spacer = undefined)->
  str = JSON.stringify json, replacer, spacer
  # console.log 'writeJSON', str, 'from', json
  await mkdirp path.dirname filepath
  await fs.writeFile filepath, str


Object.assign exports, {
  read
  readSync
  write
  writeSync
}
