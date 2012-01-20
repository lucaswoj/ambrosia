Vows = require "vows"
assert = require "assert"
_ = require "underscore"

Ambrosia = require "../../dist/ambrosia"
{$, Zepto} = Ambrosia

Vows.describe("Handlebars View").addBatch(
  
  "A simple handlebars view will":
  
    topic: -> new Ambrosia.HandlebarsView
      source: "test"
    
    "render correctly": (view) ->
      assert.equal view.element.innerHTML, "test"
      
  "A handlebars view with an inline value will":

    topic: -> new Ambrosia.HandlebarsView
      source: "{{number}}"
      context: { number: 42 }

    "render correctly": (view) ->
      assert.equal view.element.innerHTML, "42"
    
  "A handlebars view with a live value will":

    topic: -> new Ambrosia.HandlebarsView
      source: "{{number.get}}"
      context: { number: new Ambrosia.LiveValue 42 }

    "render correctly initially": (view) ->
      assert.equal view.element.innerHTML, "42"  
      
    "render correctly if the value changes": (view) ->
      view.context.number.set 17
      assert.equal view.element.innerHTML, "17"
    

).export(module)