Vows = require "vows"
assert = require "assert"
_ = require "underscore"

Ambrosia = require "../dist/ambrosia"

Vows.describe("Utility Functions").addBatch(
  
  "The _.capitalize method":
    
    "capitalizes strings": ->
      assert.equal _.capitalize("test"), "Test"
      
    "capitalizes one characeter long strings": ->
      assert.equal _.capitalize("t"), "T"
      
    "does nothing for an empty string": ->
      assert.equal _.capitalize(""), ""
      
  "The _.mapObject method":
    
    "maps objects": ->
      input = one: 1, two: 2
      expected = one: "one -> 1", two: "two -> 2",
      output = _.mapObject input, (value, key) -> "#{key} -> #{value}"
      assert.deepEqual output, expected
      
    "maps empty objects to empty objects": ->
      assert.deepEqual {}, _.mapObject({}, ->)
    
).export(module)