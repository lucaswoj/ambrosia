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
  
  # The default underscore.js `_.clone` method does not handle Arrays correctly.
  # Adapted from http://my.opera.com/GreyWyvern/blog/show.dml/1725165
  clone2: (original) ->
    if typeof original in ["object", "array"]
      clone = if _.isArray(original) then [] else {}
      for key, value of original
        clone[key] = _.clone2 value
      clone
    else
      original

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