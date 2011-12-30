class Ambrosia.LiveObject extends Ambrosia.Eventable
  
  constructor: (attributes) ->
    super
    @attributes = {}
    for name, getter of attributes
      attribute = new Ambrosia.LiveValue getter
      @attributes[name] = @[name] = attribute
      attribute.bind "change", => @trigger "change", arguments
  
  get: (name) ->
    @attributes[name].get()
    
  flatten: ->
    @trigger "get"
    flattened = {}
    for name, attribute of @attributes
      flattened[name] = attribute.get()
    flattened
    
  set: (name, getter) ->
    
    if arguments.length == 2
      getters = {}
      getters[name] = getter
    else
      getters = name
      
    for name, getter of getters
      @attributes[name].set(getter)
  
  