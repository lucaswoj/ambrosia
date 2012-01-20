Ambrosia = window?.Ambrosia || module.exports
{ _ } = Ambrosia

class Ambrosia.LiveValue extends Ambrosia.Live
    
  constructor: (value) ->
    super
    @dependencies = []
    @set value
  
  get: => 
    @trigger "get"
    @value
    
  set: (value) ->
    
    @triggerAround "set", =>
      
      if value instanceof Ambrosia.LiveValue
        @setMirror(value)
      else if _.isFunction value
        @setComputed(value)
      else
        @setStatic(value)
  
  setMirror: (mirrored) ->
    @setComputed -> mirrored.get()
  
  setStatic: (value) ->
    @triggerAround "change", ->
      @value = value
  
  setComputed: (compute) ->
        
    clear = =>
      for dependency in @dependencies
        dependency.unbind change: refresh
      @dependencies = []
    
    refresh = =>
    
      clear()
    
      @triggerAround "change", =>
        @dependencies = Ambrosia.Live.dependencies =>
          @value = compute()
      
      for dependency in @dependencies
        dependency.bind(change: refresh)
    
    refresh()
    
    @bindOnce "beforeSet", clear