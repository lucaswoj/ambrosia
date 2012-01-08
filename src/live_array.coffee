Ambrosia = window?.Ambrosia || module.exports
{ _ } = Ambrosia

## TODO: sorting
class Ambrosia.LiveArray extends Ambrosia.Eventable
  
  # ## new LiveArray
  constructor: (values = []) ->
    super
    @values = []
    @length = new Ambrosia.LiveValue @values.length
    @set values

  # ## Read and Write
  
  # ### LiveArray::set
  set: ->
    
    if arguments.length == 2
      values = {}
      values[arguments[0]] = arguments[1]
    else if arguments.length == 1
      values = arguments[0]

    @triggerAround "set", ->
      if values instanceof Ambrosia.LiveArray
        refresh = (start, amount, values...) =>
          @splice.apply(@, [start, amount].concat(values))
        values.bindNowSplice(refresh)
        @bindOnce("beforeSet", -> values.unbind("change", refresh))
      else if _.isArray(arguments) or _.isObject(arguments)
        for index, value of values
          @splice(parseInt(index, 10), 1, value)
      
  # ### LiveArray::get
  get: (index) ->
    @values[index]  
  
  # ### LiveArray::flatten
  flatten: ->
    @values
    
  # ## Basic Array Operations
  
  # ### LiveArray::push
  push: (values...) ->
    @splice.apply @, [@values.length, 0].concat(values)

  # ### LiveArray::pop
  pop: ->
    @splice @values.length - 1, 1
  
  # ### LiveArray::unshift
  unshift: (values...) ->
    @splice.apply @, [0, 0].concat(values)
  
  # ### LiveArray::shift
  shift: ->
    @splice 0, 1
    
  refreshLength: ->
    @length.set @values.length
  
  # ## Manipulation Base Case
  splice: (startIndex, amount, values...) ->
    
    args = arguments
    
    @triggerAround "change", =>
      @triggerAround "splice", args, =>

        # Remove values
        _.times amount, =>
          value = @values[index]
          @triggerAround "remove", [value, index], =>
            @values.splice(startIndex, 1)
            @refreshLength()
      
        # Add values
        for value, offset in values
          index = startIndex + offset
          @triggerAround "add", [value, index], =>
            @values.splice(index, 0, value)
            @refreshLength()
            
  bindNowSplice: (listener) ->
    @bindNow("splice", [0, 0].concat(@values), listener)
          
  liveMap: (filter) ->
    
    # Wrap filterd values in a LiveValue
    wrap = (startIndex, values) =>
      _.map values, (value, offset) ->
        index = startIndex + offset
        liveValue = new Ambrosia.LiveValue -> filter(value, index)
        liveValue.bind "change", -> map.set(index, liveValue.get())
        liveValue
    
    # Flatten liveValues
    flatten = (liveValues) ->
      _.map liveValues, (liveValue) -> liveValue.get()
      
    liveValues = wrap(0, @values)
    map = new Ambrosia.LiveArray flatten(liveValues)
    
    @bind "splice", (startIndex, amount, newValues...) =>
            
      # Unbind removed values
      for liveValue in liveValues.slice(startIndex, startIndex + amount)
        liveValue.unbind()
            
      # Find all moved values 
      movedValues = @values.slice(startIndex + amount + 1)
      
      newValues = newValues.concat(movedValues)
      newLiveValues = wrap(startIndex, newValues)
      amount += movedValues.length
      
      liveValues.splice.apply liveValues, [startIndex, amount].concat(newLiveValues)      
      map.splice.apply map, [startIndex, amount].concat(flatten(newLiveValues))
    
    map
    
  
