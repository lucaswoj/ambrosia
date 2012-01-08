Ambrosia = window?.Ambrosia || module.exports
{ _ } = Ambrosia

class Ambrosia.LiveValue extends Ambrosia.Eventable
    
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
  
    @dependencies = []
  
    clear = =>
      
      # Unbind and clear existing dependencies
      for dependency in @dependencies
        dependency.unbind change: refresh
      @dependencies = []
    
    refresh = @refresh = =>
    
      clear()
    
      # Callback to be run on each dependency
      dependencies = @dependencies
      add = ->
        dependencies.push @
        @bind change: refresh
    
      # Watch for dependencies
      @triggerAround "change", =>
        Ambrosia.LiveValue.instanceBind get: add
        @value = compute()
        Ambrosia.LiveValue.instanceUnbind get: add
    
    refresh()
    
    @bindOnce "beforeSet", ->
      clear()
      @refresh = ->