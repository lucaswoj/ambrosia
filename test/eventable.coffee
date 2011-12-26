Vows = require "vows"
assert = require "assert"

Ambrosia = require "../dist/ambrosia"
_ = Ambrosia.util

Vows.describe("Eventable Class").addBatch(
  
  "An instance of Eventable will":
  
    topic: -> new Ambrosia.Eventable
    
    "fire a listener when its event is triggered": (emitter) ->
      fired = false
      emitter.bind banana: -> fired = true
      emitter.trigger "banana"
      assert.ok fired
      
    "accept listeners in object or simple forms": (emitter) ->
      object = false
      simple = false
      emitter.bind cantelope: -> object = true
      emitter.bind "cantelope", -> simple = true
      emitter.trigger "cantelope"
      assert.ok object, "Object form is broken"
      assert.ok simple, "Simple form is broken"
      
    "pass arguments to listeners": (emitter) ->
      emitter.bind grapefruit: (answer) -> assert.equal answer, 42
      emitter.trigger "grapefruit", 42
      
    "fire its listeners multiple times": (emitter) ->
      fired = 0
      emitter.bind orange: -> fired++
      _.times 5, -> emitter.trigger "orange"
      assert.equal fired, 5
    
    "fire its listeners with scope": (emitter) ->
      emitter.bind pineapple: -> assert.equal emitter, @
      emitter.trigger "pineapple"
    
    "unbind listeners": (emitter) ->
      fired = 0
      events =  kiwi: -> fired++
      emitter.bind events
      _.times 2, -> emitter.trigger "kiwi"
      emitter.unbind events
      _.times 2, -> emitter.trigger "kiwi"
      assert.equal fired, 2
    
    "fire a bindOnce listener only once": (emitter) ->
      fired = 0
      emitter.bindOnce apple: -> fired++
      _.times 5, -> emitter.trigger "apple"
      assert.equal fired, 1
      
    "fire all triggerAround events in sequence": (emitter) ->
      fired = 0
      emitter.bind beforeWatermelon: -> assert.equal fired++, 0
      emitter.bind watermelon: -> assert.equal fired++, 1
      emitter.bind afterWatermelon: -> assert.equal fired++, 2
      emitter.triggerAround "watermelon", ->
      assert.equal fired, 3
        
    "pass arguments to all triggerAround events": (emitter) ->
      fired = 0
      emitter.bind beforePear: (answer) -> assert.equal answer, 42
      emitter.bind pear: (answer) -> assert.equal answer, 42
      emitter.bind afterPear: (answer) -> assert.equal answer, 42
      emitter.triggerAround "pear", 42, ->
    
    "fire class listeners": (emitter) ->
      fired = false
      Ambrosia.Eventable.instanceBind strawberry: -> fired = true
      emitter.trigger "strawberry"
      assert.ok fired
      
    "fire ancestor class listeners": ->
      fired = false
      class Grandparent extends Ambrosia.Eventable
      class Parent extends Grandparent
      emitter = new Parent
      Grandparent.instanceBind cranberry: -> fired = true  
      emitter.trigger "cranberry"
      assert.ok fired
    
    "pass arguments to class listeners": (emitter) ->
      Ambrosia.Eventable.instanceBind lime: (answer) -> assert.equal answer, 42
      emitter.trigger "lime", 42
      
    "run class listeners with scope": (emitter) ->
      Ambrosia.Eventable.instanceBind blueberry: -> assert.equal @, emitter
      emitter.trigger "blueberry"
      
    "unbind class listeners": (emitter) ->
      fired = 0
      events =  raspberry: -> fired++
      Ambrosia.Eventable.instanceBind events
      _.times 2, -> emitter.trigger "raspberry"
      Ambrosia.Eventable.instanceUnbind events
      _.times 2, -> emitter.trigger "raspberry"
      assert.equal fired, 2
      
    "fire a class bindOnce listener only once": (emitter) ->
      fired = 0
      Ambrosia.Eventable.instanceBindOnce avacado: -> fired++
      _.times 5, -> emitter.trigger "avacado"
      assert.equal fired, 1
    
).export(module)