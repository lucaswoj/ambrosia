Ambrosia = window?.Ambrosia || module.exports
{ _ } = Ambrosia

_.mixin
  
  mapObject: (input, filter) ->
    output = {}
    output[key] = filter(value, key) for key, value of input
    output
    
  capitalize: (string) ->
    if string.length
      string[0].toUpperCase() + string.slice(1)
    else
      ""
  
  isObject: (object) ->
    object.constructor == Object

# TODO move to seperate testing library
if Ambrosia.node
  assert = require("assert")
  _.extend assert,

    event: (name, object, action) ->
      fired = false
      listener = -> fired = true
      object.bind name, listener
      action()
      object.unbind name, listener
      assert.ok fired, "Expected '#{name}' event to be triggered but it was not"