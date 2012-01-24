Ambrosia = window?.Ambrosia || module.exports
{ _ } = Ambrosia

class Ambrosia.Eventable
  
  @events = {}
  
  @instanceBind: ->
    events = parseArgs(arguments)
    for event, listener of events
      event = (Ambrosia.Eventable.events[@] ||= {})[event] ||= []
      event.push listener
      
  @instanceBindOnce: ->
    events = parseArgs(arguments)
    events = _.mapObject events, (listener) => =>
      @instanceUnbind events
      listener()
    @instanceBind events
      
  @instanceUnbind: ->
    events = parseArgs(arguments)
    for event, listener of events
      listeners = Ambrosia.Eventable.events[@]
      listeners[event] = _.without(listeners[event], listener)

  constructor: ->
    @events = {}
  
  bind: ->
    events = parseArgs(arguments)
    for event, listener of events
      event = @events[event] ||= []
      event.push listener

  bindOnce: ->
    events = parseArgs(arguments)
    events = _.mapObject events, (listener) -> ->
      @unbind(events)
      listener()
    @bind(events)

  bindNow: ->
    events = parseArgs(arguments)
    args = if arguments.length is 3 then arguments[1] else []
    listener.apply(@, args) for event, listener of events
    @bind(events)
      
  unbind: ->
    
    # Unbind everything
    if arguments.length == 0
      @events = {}
      
    # Unbind all listeners for a specific event
    else if arguments.length == 1 && _.isString(arguments[0])
      @events[arguments[0]] = []
    
    # Unbind a single listener
    else
      events = parseArgs(arguments)
      for event, listener of events
        @events[event] = _.without @events[event], listener
      
  triggerAround: (event, args, action) ->
    
    if arguments.length == 3
      [event, args, action] = arguments
    else if arguments.length == 2
      [event, action] = arguments
      args = []
    
    @trigger.call @, "before#{_.capitalize(event)}", args
    action.call @
    @trigger.call @, event, args
    @trigger.call @, "after#{_.capitalize(event)}", args
  
  ancestors = _.memoize (ancestor) ->
      while ancestor
        ancestor = ancestor.__super__?.constructor
  
  trigger: (event, args = []) ->
            
    # Run class listeners
    for ancestor in ancestors(@constructor)
      if Eventable.events[ancestor]?[event]?
        for listener in Eventable.events[ancestor][event]
          listener.apply @, args
    
    # Run instance listeners
    if @events[event]?
      for listener in @events[event]
        listener.apply @, args
    
  parseArgs = (args) ->
    
    # If arguments have the form (events)
    if args.length == 1
      args[0]
      
    # If arguments have the form (event, listener)
    else if args.length == 2
      events = {}
      events[args[0]] = args[1]
      events
      
    # If arguments have the form (event, args..., listener)
    else if args.length == 3
      events = {}
      events[args[0]] = args[2]
      events