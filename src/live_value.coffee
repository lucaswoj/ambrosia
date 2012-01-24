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
    
  decrement: ->
    @set(@get() - 1)
  
  increment: ->
    @set(@get() + 1)
    
  clear: ->
    for dependency in @dependencies
      dependency.unbind change: @refresh
    @dependencies = []
  
  set: (value) ->
    
    @triggerAround "set", =>
        
      if value instanceof Ambrosia.LiveValue
        @compute = -> value.get()
      else if _.isFunction(value)
        @compute = value
      else
        @compute = -> value
  
      @refresh()
        
  refresh: =>
    
    @clear()
    
    @triggerAround "change", =>
      @dependencies = Ambrosia.Live.dependencies =>
        @value = @compute()
      
    for dependency in @dependencies
      dependency.bind(change: @refresh)

          
      
      
      