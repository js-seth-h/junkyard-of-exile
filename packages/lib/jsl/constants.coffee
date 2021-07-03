#
is_constants = Symbol('is_constants')
# LAST_ACCESS_NAME = null

constants = (data)->
  getNameOf = (val)->
    for own k, v of data
      # console.log 'Nameof', val, k, v
      return k if v is val
    return "Unknown"

  P = new Proxy data,
    set: ()->
      throw new Error "can not assign on constants"
    get: (target, name)->
      # console.log 'get of ConstWrap'
      if name is 'toString'
        return getNameOf
      if name is is_constants
        return true
      if typeof name is 'symbol'
        return undefined
      unless target.hasOwnProperty name
        throw new Error "You try to access undefined constant(=#{name})"
      # console.log 'access', name, target[name]
      if target[is_constants]
        return target
      ref_val = target[name]
      LAST_ACCESS_NAME = name
      if ref_val[is_constants]
        return ref_val
      if ref_val instanceof Object or Array.isArray ref_val
        # return constants ref_val
        return ref_val
      # ref_val.CSTR = name
      return ref_val
  # P.prototype.valueOf = ()->
  #   alert 'constants valueOf'
  return P
module.exports = constants
