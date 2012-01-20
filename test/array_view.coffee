Vows = require "vows"
assert = require "assert"
_ = require "underscore"

Ambrosia = require "../dist/ambrosia"
{$, Zepto} = Ambrosia

class ChildView extends Ambrosia.View
  constructor: (options) ->
    super text: options.model

Vows.describe("Array View").addBatch(
  
  "An ArrayView will":
  
    topic: -> 
      new Ambrosia.ArrayView
        children: new Ambrosia.LiveArray ["one", "two"]
        childView: ChildView
      
    "have the correct child elements": (view) ->
      texts = _.map view.$element.children(), (element) -> $(element).text()
      assert.deepEqual texts, ["one", "two"]
      
    "update its values": (view) ->
      view.children.push("three")
      
    "have the correct child elements after updating its value": (view) ->
      texts = _.map view.$element.children(), (element) -> $(element).text()
      assert.deepEqual texts, ["one", "two", "three"]

).export(module)