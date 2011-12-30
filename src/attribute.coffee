class Ambrosia.Attribute extends Ambrosia.Eventable
  
  constructor: (getter) ->
    super
    @dependencies = []
    @set getter
  
  get: -> 
    @trigger "get", []
    @value
    
  set: (getter = ->) ->
    
    @triggerAround "set", [], ->
    
      # Turn the getter into a simple function
      if _.isFunction(getter)
        @getter = getter
      else if getter instanceof Ambrosia.Attribute
        @getter = -> getter.get()
      else
        @getter = -> getter
    
      # Refresh the attribute's value
      @refresh()
  
  refresh: ->

    watch = => @refresh()
    
    # Unbind and clear existing dependencies
    for dependency in @dependencies
      dependency.unbind change: watch
    @dependencies = []
    
    # Callback to be run on each dependency
    dependencies = @dependencies
    add = ->
      dependencies.push @
      @bind change: watch
    
    # Watch for dependencies
    @triggerAround "change", [], =>
      Ambrosia.Attribute.instanceBind get: add
      @value = @getter()
      Ambrosia.Attribute.instanceUnbind get: add
  