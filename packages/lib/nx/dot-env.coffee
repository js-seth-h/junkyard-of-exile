dotenv = require 'dotenv'
dotenvExpand = require('dotenv-expand')

path = require 'path'
fs = require 'fs'

filename = '.env'
if process.env.DOT_ENV_NAME?
  if process.env.DOT_ENV_NAME isnt 'default'
    filename += '.' + process.env.DOT_ENV_NAME
env_path = path.resolve(process.cwd(), filename)

console.log 'dotEnv:', env_path
if fs.existsSync env_path
  result = dotenv.config path: env_path
  if result.error?
    throw result.error
  dotenvExpand result
  # return unless fs.existsSync '.env'
