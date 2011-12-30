Vows = require "vows"
assert = require "assert"

Ambrosia = require "../dist/ambrosia"
_ = Ambrosia.util

assert.event = (name, object, action) ->
  fired = false
  listener = -> fired = true
  object.bind name, listener
  action()
  object.unbind name, listener
  assert.ok fired, "Expected '#{name}' event to be triggered but it was not"

Vows.describe("Utility Functions").addBatch(
  
  "An object with a static attribute will":
    
    topic: ->
      new Ambrosia.LiveObject color: "orange"
      
    "have the attribute": (object) ->
      assert.instanceOf object.color, Ambrosia.LiveValue
      assert.instanceOf object.attributes.color, Ambrosia.LiveValue
    
    "fire a 'change' event when the attribute changes": (object) ->
      assert.event "change", object, -> object.color.set "red"
      
    "get the attribute's value": (object) ->
      assert.equal object.get("color"), "red"
      
    "set the attribute's value": (object) ->
      object.set("color", "green")
      assert.equal object.get("color"), "green"
      
    "set the attribute's value via a hash": (object) ->
      object.set(color: "tope")
      assert.equal object.get("color"), "tope"
      
    "flatten to a native javascript object": (object) ->
      assert.deepEqual object.flatten(), color: "tope"

).export(module)