dcon = require('deco-console')(__filename)
R = require 'ramda'
RA = require 'ramda-adjunct'
J = require 'jsl'


_notate = R.curry (notater, key, str)->
  # dcon.debug '_notate', {key, v}
  {notates, delimeter} = notater
  for own type_name, hint of notates
    # if this[key].constructor?.name is type_name
    if this[key] instanceof hint.type
      # dcon.debug '_notate?', v.constructor?.name is type_name
      return str + delimeter + type_name + delimeter
  return str
_unnotate = R.curry (notater, key, value)->
  {notates, delimeter} = notater
  return value if RA.isNilOrEmpty value
  if R.endsWith delimeter, value
    [str, type_name] = R.split delimeter, value
    # dcon.debug '_unnotate', str, type_name, notates[type_name].recover_fn str
    return notates[type_name].recover_fn str
  return value


class Notater
  constructor: ->
    @delimeter = ' ~/@/~ '
    @notates = {}
  add: (type, recover_fn)->
    type_name = type.prototype.constructor.name
    @notates[type_name] = {
      type
      recover_fn
    }
  stringify: (obj)->
    JSON.parse JSON.stringify obj, _notate(this), 2
  parse: (obj)->
    JSON.parse JSON.stringify(obj), _unnotate(this)
    # console.log d.app_license
    # return d
module.exports = Notater
