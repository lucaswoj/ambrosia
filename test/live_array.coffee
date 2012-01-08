Vows = require "vows"
assert = require "assert"
_ = require "underscore"

Ambrosia = require "../dist/ambrosia"

Vows.describe("LiveArray").addBatch(
  
  "A LiveArray with one value will":
    
    topic: ->
      new Ambrosia.LiveArray ["trout"]

    "flatten to a native javascript array": (array) ->
      flattened = array.flatten()
      assert.instanceOf flattened, Array
      
  "A LiveArray with several values will":    
    
    topic: ->
      new Ambrosia.LiveArray ["cod", "halibut", "herring"]
    
    "use 'splice' to manipulate the array": (array) ->
      array.splice 1, 1, "flounder"
      assert.deepEqual array.flatten(), ["cod", "flounder", "herring"]
      
    "push objects on to the end of the array": (array) ->
      array.push "tuna"
      assert.deepEqual array.flatten(), ["cod", "flounder", "herring", "tuna"]
      
    "pop objects off the end of the array": (array) ->
      array.pop()
      assert.deepEqual array.flatten(), ["cod", "flounder", "herring"]
      
    "trigger the 'splice' event whenever the array is manipulated": (array) ->
      assert.event "splice", array, -> 
        array.pop()
        assert.deepEqual array.flatten(), ["cod", "flounder"]
      
    "maintain its length value": (array) ->
      assert.equal array.length.get(), array.values.length
      
    "unshift objects to the beginning of the array": (array) ->
      array.unshift "mackerel"
      assert.deepEqual array.flatten(), ["mackerel", "cod", "flounder"]
      
    "get objects from the array": (array) ->
      assert.equal array.get(0), "mackerel"
      
    "set objects in the array": (array) ->
      array.set 0, "parrotfish"
      assert.deepEqual array.flatten(), ["parrotfish", "cod", "flounder"]
      
    "set objects in the array with a hash": (array) ->
      array.set({1: "sailfish"})
      assert.deepEqual array.flatten(), ["parrotfish", "sailfish", "flounder"]
      
    "shift objects from the array": (array) ->
      array.shift()
      assert.deepEqual array.flatten(), ["sailfish", "flounder"]
      
  "A mapped LiveArray":
    
    topic: ->
      numbers: numbers = new Ambrosia.LiveArray [1, 2, 3]
      evens: numbers.liveMap (number) -> number * 2
    
    "has the correct initial values": (arrays) ->
      assert.deepEqual arrays.evens.flatten(), [2, 4, 6]
      
    "reflects pushes": (arrays) ->
      arrays.numbers.push 4
      assert.deepEqual arrays.evens.flatten(), [2, 4, 6, 8]
      
    "reflects shifts": (arrays) ->
      arrays.numbers.unshift 0
      assert.deepEqual arrays.evens.flatten(), [0, 2, 4, 6, 8]

).export(module)