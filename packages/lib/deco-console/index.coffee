env = require './env'
R = require 'ramda'
c = require 'ansi-colors'

if process?
  { Console } = require('console')
  # console.log {Console}
  if Console?
    my_console = new Console {
      stdout: process.stdout, stderr: process.stderr
      inspectOptions:
        depth: 8
        maxArrayLength: 10
        # maxStringLength: 5
    }
unless my_console?
  my_console = globalThis.console

color_set = [
  c.red
  c.green
  c.blue
  c.yellow
  c.magenta
  c.cyan

  c.redBright
  c.greenBright
  c.blueBright
  c.yellowBright
  c.magentaBright
  c.cyanBright

  c.dim.red
  c.dim.green
  c.dim.blue
  c.dim.yellow
  c.dim.magenta
  c.dim.cyan

  c.dim.redBright
  c.dim.greenBright
  c.dim.blueBright
  c.dim.yellowBright
  c.dim.magentaBright
  c.dim.cyanBright
]
log_lv =
  error: c.red    'error'
  warn:  c.yellow 'warn '
  info:  c.cyan   'info '
  log:   c.green  'log  '
  debug: c.red    'debug'
  error_force: c.red    'F.error'
  warn_force:  c.yellow 'F.warn '
  info_force:  c.cyan   'F.info '
  log_force:   c.green  'F.log  '
  debug_force: c.red    'F.debug'


N_C_INX = 0
module.exports = (filepath)->
  [filepath] = R.split '?', filepath

  coloring = color_set[N_C_INX]
  N_C_INX++
  N_C_INX = 0 if N_C_INX >= color_set.length

  M =
    F:
      error: (args...)->
        prefix = "#{log_lv.error_force} #{env.dt()} #{coloring env.moduleId filepath}"
        my_console.error prefix, args...
      warn: (args...)->
        prefix = "#{log_lv.warn_force} #{env.dt()} #{coloring env.moduleId filepath}"
        my_console.warn prefix, args...
      info: (args...)->
        prefix = "#{log_lv.info_force} #{env.dt()} #{coloring env.moduleId filepath}"
        my_console.info prefix, args...
      log: (args...)->
        prefix = "#{log_lv.log_force} #{env.dt()} #{coloring env.moduleId filepath}"
        my_console.log prefix, args...
      debug: (args...)->
        prefix = "#{log_lv.debug_force} #{env.dt()} #{coloring env.moduleId filepath}"
        my_console.debug prefix, args...
    error: (args...)->
      return unless env.onoff.error
      prefix = "#{log_lv.error} #{env.dt()} #{coloring env.moduleId filepath}"
      my_console.error prefix, args...
    warn: (args...)->
      return unless env.onoff.warn
      # my_console.warn log_lv.warn, env.dt(), coloring env.moduleId filepath, args...
      prefix = "#{log_lv.warn} #{env.dt()} #{coloring env.moduleId filepath}"
      my_console.warn prefix, args...
    info: (args...)->
      return unless env.onoff.info
      # my_console.info log_lv.info, env.dt(), coloring env.moduleId filepath, args...
      prefix = "#{log_lv.info} #{env.dt()} #{coloring env.moduleId filepath}"
      my_console.info prefix, args...
    log: (args...)->
      return unless env.onoff.log
      # my_console.log log_lv.log, env.dt(), coloring env.moduleId filepath, args...
      prefix = "#{log_lv.log} #{env.dt()} #{coloring env.moduleId filepath}"
      my_console.log prefix, args...
    debug: (args...)->
      return unless env.onoff.debug
      # my_console.debug log_lv.debug, env.dt(), coloring env.moduleId filepath, args...
      prefix = "#{log_lv.debug} #{env.dt()} #{coloring env.moduleId filepath}"
      my_console.debug prefix, args...
    uptime: ()-> env.getDT_S()
  M.verbose = M.verb = M.log
  return M
