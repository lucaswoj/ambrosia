#= require_self
#= require ./util
#= require ./eventable
#= require ./attribute
#= require_tree .

Ambrosia = {}

if require? && module?
  module.exports = global.Ambrosia = Ambrosia
  Ambrosia.util = _ = global._ = require("underscore")
else if window?
  window.Ambrosia = Ambrosia
  Ambrosia.util = _ = window._