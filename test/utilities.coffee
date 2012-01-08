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
      
  "The _.clone2 method":
    
    "clones objects": ->
      original = { one: 1 }
      clone = _.clone2 original
      original["one"] = 2
      assert.equal clone["one"], 1
      
    "clones arrays": ->
      original = ["zero"]
      clone = _.clone2 original
      original[0] = "one"
      assert.equal clone[0], "zero"
      assert.instanceOf clone, Array
      
  "The _.mapObject method":
    
    "maps objects": ->
      input = one: 1, two: 2
      expected = one: "one -> 1", two: "two -> 2",
      output = _.mapObject input, (value, key) -> "#{key} -> #{value}"
      assert.deepEqual output, expected
      
    "maps empty objects to empty objects": ->
      assert.deepEqual {}, _.mapObject({}, ->)
    
).export(module)