class Ambrosia.Eventable
  
  @events = {}
  
  @instanceBind: ->
    events = argumentsToObject(arguments)
    for name, listener of events
      event = (Eventable.events[@] ||= {})[name] ||= []
      event.push listener
      
  @instanceBindOnce: ->
    events = argumentsToObject(arguments)
    events = _.mapObject events, (listener) => =>
      @instanceUnbind events
      listener()
    @instanceBind events
      
  @instanceUnbind: ->
    events = argumentsToObject(arguments)
    for name, listener of events
      @events[@][name] = _.without @events[@][name], listener

  constructor: ->
    @events = {}
  
  bind: ->
    events = argumentsToObject(arguments)
    for name, listener of events
      event = @events[name] ||= []
      event.push listener
      
  bindOnce: ->
    events = argumentsToObject(arguments)
    events = _.mapObject events, (listener) -> ->
      @unbind events
      listener()
    @bind events
      
  unbind: ->
    events = argumentsToObject(arguments)
    for name, listener of events
      @events[name] = _.without @events[name], listener
      
  triggerAround: (name, args, action) ->
    @trigger.call @, "before#{_.capitalize(name)}", args
    action()
    @trigger.call @, name, args
    @trigger.call @, "after#{_.capitalize(name)}", args
    
  trigger: (name, args) ->
    
    # Run class listeners
    ancestor = @constructor
    while ancestor
      if Eventable.events[ancestor]?[name]?
        for listener in Eventable.events[ancestor][name]
          listener.apply @, args
      ancestor = ancestor.__super__?.constructor
    
    # Run instance listeners
    if @events[name]?
      for listener in @events[name]
        listener.apply @, args
      
  argumentsToObject = (args) ->
    if args.length == 2 
      events = {}
      events[args[0]] = args[1]
      events
    else if args.length == 1
      args[0]