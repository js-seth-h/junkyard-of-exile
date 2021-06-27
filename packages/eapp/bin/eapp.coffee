#!/usr/bin/env coffee

electron_exec = require 'electron'
childp = require 'child_process'
path = require 'path'
R = require 'ramda'

args = require('minimist')(process.argv.slice(2));
console.log args

try
  main = path.resolve(__dirname, '../electron-launch.js')
  childp.execSync "#{electron_exec} #{main}",
    stdio: 'inherit'
    env: R.mergeRight process.env, {args: JSON.stringify args}
catch error
  console.error error
  process.exit 1
