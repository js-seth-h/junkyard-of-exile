R = require 'ramda'
RA = require 'ramda-adjunct'
path = require 'path'

dcon = require('deco-console')(__filename)
{ clipboard } = require('electron')
EventEmitter = require('events');

EBUS = new EventEmitter()
module.exports = EBUS

PREV_TXT = ""
checkClipboard = ->
  text = clipboard.readText()
  return if PREV_TXT is text
  PREV_TXT = text
  return if not R.includes '--------', text
  console.log "copyied text", {text}
  EBUS.emit "poe-item-copied", text


setInterval checkClipboard, 300
