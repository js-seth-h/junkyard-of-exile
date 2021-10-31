R = require 'ramda'
RA = require 'ramda-adjunct'
path = require 'path'

dcon = require('deco-console')(__filename)
DCON_ENV = require('deco-console/env')
electron = require('electron')
{
  app, BrowserWindow,
  Tray, nativeImage, Menu
} = electron

G = {}

main = ()->
  DCON_ENV.shorten (p)-> p.replace /.+packages\/(.+?)\//, ''
  DCON_ENV.detail parseInt(process.env.DCON_VERBOSE) or 1
  DCON_ENV.formatDatetime process.env.DCON_DT or 'T'

  args = JSON.parse process.env.args



  try
    console.log 'process.args', args
    # console.log '!! process.env', process.env
    dir = path.dirname(process.execPath);
    # fp = path.join(dir, './.CHDIR');
    # if fs.existsSync(fp)
    #   process.chdir(dir)
    # # dcon.debug 'load 5'
    # Object.assign process.env, ctx.opts
    # require('bedrock/config').consolidateSync 'dev'
    # # dcon_ENV.setOpts {
    #   time: process.env.# dcon_DT or 'T'
    #   detail: parseInt(process.env.# dcon_VERBOSE) or 1
    # }
    # await require('cips/elec-app')()
    await createWindow()

    webserver = require 'webserver'
    await webserver.createServer()
    url = args.url or args.u or "http://localhost:1234"
    # url = "http://naver.com"
    await G.MAIN_WINDOW.loadURL url

    ws = require 'webserver/ws'
    sensor_poecopy = require './sensor-copy'
    sensor_poecopy.on 'poe-item-copied', (text)->
      dcon.F.debug 'copied', text
      ws.addItem text
    #
    # ws.on 'message', (json_str)->
    #   data = JSON.parse evt.data
    #
    #   if data.cmd is 'openUrl'
    #     open = require('open')
    #     open data.url

  catch error
    console.error error
    process.exit(1)

createWindow = ->
  # dcon.debug 'build electron'
  gotTheLock = app.requestSingleInstanceLock()
  # dcon.debug 'gotTheLock', gotTheLock
  unless gotTheLock
    throw new Error 'Duplicated Application'

  await app.whenReady()
  wnd = new BrowserWindow {
    webPreferences: {
        webSecurity: false
    }
  }
  # wnd.setMenu(null) # 상단 메뉴 제거
  wnd.on 'closed', ->
    G.MAIN_WINDOW = null

  {x, y, width, height} = getWindowRect()
  wnd.setPosition x, y
  wnd.setSize width, height
  wnd.maximize()
  wnd.webContents.openDevTools()

  G.MAIN_WINDOW = wnd


getWindowRect = ()->
  displays = electron.screen.getAllDisplays()
  setRank = (d)->
    d.score = 99 - Math.abs(d.workArea.x) / 100
    if d.size.height >= 1800
      d.score += 100

  R.forEach setRank, displays
  # dcon.debug 'displays = ', displays
  displays = R.reverse R.sortBy R.prop('score'), displays

  display = R.head displays
  # dcon.debug 'prefer display ', display
  return rect =
    x: display.workArea.x
    y: display.workArea.y
    width: display.workArea.width
    height: display.workArea.height


Object.assign exports, {
  main
}
