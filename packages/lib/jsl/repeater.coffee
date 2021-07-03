dcon = require('deco-console')(__filename)
R = require 'ramda'
RA = require 'ramda-adjunct'
moment = require 'moment'
cron = require('cron-parser')


class Repeater
  constructor: (@repeat_rule, @fn)->
    @IS_WORKING = false
    @waiters = []
  getNext: ()->
    # dcon.debug '@repeat_rule', @repeat_rule
    if R.is Number, @repeat_rule
      return @repeat_rule

    interval = cron.parseExpression(@repeat_rule)
    ms = 0
    while ms <= 0
      dt = moment interval.next().toDate()
      dt.millisecond(0)
      ms = dt - moment()
    # dcon.debug 'dt', (dt - moment())
    # dcon.verb 'setupJobSchedule next', dt.local().format(), 'timer ms =', ms
    return ms

  onTime: ()->
    @setupNext()
    return if @IS_WORKING
    try
      @IS_WORKING = true
      await @fn()
      for j in @waiters
        j true
    catch error
      console.error error
    finally
      @IS_WORKING = false

  setupNext: (ms)->
    ms = @getNext() unless ms
    @timer_id = setTimeout R.bind(@onTime, this), ms
    moment().add(ms, 'ms')

  waitOnce: ->
    new Promise (done)=>
      @waiters.push done
Object.assign exports, {
  Repeater
}

# IS_WORKING = false
# doOnce = ->
#   dcon.verb 'doOnce', job
#   return if IS_WORKING
#   IS_WORKING = true
#   job = new Job()
#   await job.start()
#   IS_WORKING = false
#   setupNext()
#
# setupNext = ->
#   dt = moment cron.parseExpression(CFG.cron_exp).next().toDate()
#   dt.millisecond(0)
#   ms = dt - moment()
#   dcon.debug 'dt', (dt - moment())
#   dcon.verb 'setupJobSchedule next', dt.local().format(), 'timer ms =', ms
#   if ms > Number.MAX_SAFE_INTEGER
#     throw new Error 'Invalid Schedule'
#   if ms <= 0
#     throw new Error 'Invalid Schedule'
#   setTimeout doOnce, ms
#
# setup = ->
#   if CFG.run_at_start
#     doOnce()
#   else
#     setupNext()
