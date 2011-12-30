#= require_self
#= require ./utilities
#= require ./eventable
#= require ./live_value
#= require ./live_array
#= require ./live_object
#= require_tree .

Ambrosia = { UI: {} }

if require? && module?
  module.exports = global.Ambrosia = Ambrosia
  Ambrosia.util = _ = global._ = require("underscore")
else if window?
  window.Ambrosia = Ambrosia
  Ambrosia.util = _ = window._