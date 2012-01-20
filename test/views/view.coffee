Vows = require "vows"
assert = require "assert"
_ = require "underscore"

Ambrosia = require "../../dist/ambrosia"
{$, Zepto} = Ambrosia

Vows.describe("Base View").addBatch(
  
  "A view without an element will":
  
    topic: -> new Ambrosia.View
      text: new Ambrosia.LiveValue "wrong"
    
    "create its own element": (view) ->
      assert.ok _.isElement view.element
    
    "add static classes": (view) ->
      view.addClass "static"
      assert.ok view.$element.hasClass "static"
      
    "add live classes": (view) ->
      value = new Ambrosia.LiveValue "bad"
      view.addClass value
      value.set "good"
      assert.ok view.$element.hasClass "good"
      assert.ok !view.$element.hasClass "bad"

    "update its text": (div) ->
      div.text.set("right")
      assert.equal div.$element.text(), "right"

).export(module)