Vows = require "vows"
assert = require "assert"

Ambrosia = require "../dist/ambrosia"
_ = Ambrosia.util

Vows.describe("LiveObject").addBatch(
  
  "An object with a static attribute will":
    
    topic: ->
      new Ambrosia.LiveObject color: "orange"
      
    "have the attribute": (object) ->
      assert.instanceOf object.color, Ambrosia.LiveValue
      assert.instanceOf object.values.color, Ambrosia.LiveValue
      
    "get the attribute's value": (object) ->
      assert.equal object.get("color"), "orange"
      
    "set the attribute's value": (object) ->
      object.set("color", "green")
      assert.equal object.get("color"), "green"
      
    "set the attribute's value via a hash": (object) ->
      object.set(color: "tope")
      assert.equal object.get("color"), "tope"
      
    "flatten to a native javascript object": (object) ->
      assert.deepEqual object.flatten(), color: "tope"
      
    "add attributes": (object) ->
      object.set size: "medium"
      assert.equal object.get("size"), "medium"
    
    "fire the change event when adding an attribute": (object) ->
      assert.event "change", object, ->
        object.set price: 20

).export(module)