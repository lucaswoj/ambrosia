#= require_self
#= require ./utilities
#= require ./eventable
#= require ./live_value
#= require ./live_array
#= require ./view
#= require ./template_view
#= require_tree .

Ambrosia =
  node: require? && module?
  browser: window?
  toString: -> "Ambrosia"
  View: {}

if Ambrosia.node
  
  jsdom = require "jsdom"
  fs = require "fs"
  
  module.exports = Ambrosia
  
  document = jsdom.jsdom """
    <html>
      <head>
        <script>#{fs.readFileSync("vendor/zepto.js", "utf8")}</script>
      </head>
    </html>
    """
  
  Ambrosia.document = document
  Ambrosia.window = document.createWindow()
  
  Ambrosia.Zepto = Ambrosia.window.Zepto
  Ambrosia._ = require "underscore"
  Ambrosia.$ = Ambrosia.Zepto
  Ambrosia.Handlebars = require "handlebars"

else if Ambrosia.browser

  window.Ambrosia = Ambrosia
  
  Ambrosia.window = window
  Ambrosia.docuemnt = document
  
  Ambrosia.Zepto = window.Zepto
  Ambrosia._ = window._
  Ambrosia.$ = Ambrosia.Zepto
  Ambrosia.Handlebars = window.Handlebars