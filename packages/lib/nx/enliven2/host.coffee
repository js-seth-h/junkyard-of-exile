R = require 'ramda'
RA = require 'ramda-adjunct'
dcon = require('deco-console')(__filename)
J = require 'jsl'

chokidar = require 'chokidar'
dgram = require('dgram')
{ChildProcess} = require 'child_process'
{debounce} = require 'throttle-debounce'


class EnlivenHost
  constructor: (@_spawner) ->
    @watched = {}
    @watcher = chokidar.watch __filename
    @watched[__filename] = true

    @watcher.on 'change', @_onChange
    @watcher.on 'unlink', @_onUnlink


  _onExit: (code, signal)=>
    dcon.info process.pid, ':: chk exit', @child.pid, {code, signal}
    @child = null
    # if code is CODE_REQ_RESTART
    # if signal is 'SIGKILL'
    #   @_callSpawner()
    if code is 77
      @_callSpawner()


  _onChange: (filepath)=>
    dcon.info process.pid, 'change', filepath
    if @child?
      # @child.kill 'SIGKILL'
      @server.send 'die-for-enliven', @kill_port
    else
      @_callSpawner()

  _onUnlink: (filepath)=>
    @watcher.unwatch filepath
    @watched[filepath] = false
    dcon.info process.pid, 'unlink', filepath
    if @child?
      # @child.kill 'SIGKILL'
      @server.send 'die-for-enliven', @kill_port
    else
      @_callSpawner()

  _callSpawner: ->
    return if @child?
    return if @_spawning is true
    @_spawning = true
    await J.postpone '10ms'
    @child = await @_spawner()
    @_spawning = false
    unless @child instanceof ChildProcess
      throw new Error 'HMR spawner should return ChildProcess for autoRestart()'
    dcon.info process.pid, ':: chk subp', @child.pid
    @child.on 'exit', @_onExit

  # autoRestart: (@_auto_restart)-> return this
  start: ->
    @server = dgram.createSocket 'udp4'
    # random_port = 60000 + Math.floor Math.random() * 1000
    # @server.bind random_port
    await new Promise (done)=>
      @server.bind 0, '127.0.0.1', done
    # client.bind 0
    {port: random_port} = @server.address()
    dcon.info process.pid, 'host enliven', @server.address()
    @server.on 'message', (msg)=>
      msg = msg.toString()
      if R.startsWith 'SET-PORT', msg
        [cmd, port] = R.split ' ', msg
        @kill_port = parseInt port
      else
        filepath = msg
        return if @watched[filepath] is true
        dcon.log process.pid, 'udp get', filepath
        @watcher.add filepath
        @watched[filepath] = true

    process.env.HMR_HOSTED_PORT = random_port
    dcon.debug 'new EnlivenHost ', process.env.HMR_HOSTED_PORT
    await @_callSpawner()

start = (create_child_fn)->
  host = new EnlivenHost create_child_fn
  await host.start()

Object.assign exports, {
  start
}
