Vows = require "vows"
assert = require "assert"

Ambrosia = require "../dist/ambrosia"
_ = Ambrosia.util

Vows.describe("Utility Functions").addBatch(
  
  "An attribute with a static getter will":
  
    topic: -> new Ambrosia.LiveValue "Canada"
    
    "return its value": (attribute) ->
      assert.equal attribute.get(), "Canada"
      
    "have no dependencies": (attribute) ->
      assert.deepEqual attribute.dependencies, []  
      
  "An attribute without dependencies will":

    topic: -> new Ambrosia.LiveValue -> "Mexico"

    "return its value": (attribute) ->
      assert.equal attribute.get(), "Mexico"

    "have no dependencies": (attribute) ->
      assert.deepEqual attribute.dependencies, []      
    
  "An attribute with a dependency will":

    topic: -> 
      country = new Ambrosia.LiveValue "Mexico"
      phrase = new Ambrosia.LiveValue -> "Viva #{country.get()}!"
      country: country, phrase: phrase

    "return its value": (attributes) ->
      assert.equal attributes.phrase.get(), "Viva Mexico!"

    "have its dependencies": (attributes) ->
      assert.deepEqual attributes.phrase.dependencies, [attributes.country]
      
    "return correct value after its dependency changes": (attributes) ->
      attributes.country.set "France"
      assert.deepEqual attributes.phrase.get(), "Viva France!"
      
    "An attribute with multiple dependencies will":

      topic: -> 
        first: first = new Ambrosia.LiveValue -> "Michelle"
        last: last = new Ambrosia.LiveValue -> "Obama"
        full: full = new Ambrosia.LiveValue -> "#{first.get()} #{last.get()}"

      "return its value": (attributes) ->
        assert.equal attributes.full.get(), "Michelle Obama"

      "have its dependencies": (attributes) ->
        assert.deepEqual attributes.full.dependencies.sort(), [attributes.first, attributes.last].sort()

      "return correct value after a dependency changes": (attributes) ->
        attributes.first.set "Barack"
        assert.deepEqual attributes.full.get(), "Barack Obama"
        
    "An attribute bound to another attribute":

      topic: ->
        once: once = new Ambrosia.LiveValue "Aspen"
        again: again = new Ambrosia.LiveValue once

      "will update with source attribute": (attributes) ->
        attributes.once.set "Pine"
        assert.equal attributes.again.get(), "Pine"
    
).export(module)