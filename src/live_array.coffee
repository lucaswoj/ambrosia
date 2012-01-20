Ambrosia = window?.Ambrosia || module.exports
{ _ } = Ambrosia

## TODO: sorting
class Ambrosia.LiveArray extends Ambrosia.Live
  
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
    
    map = new Ambrosia.LiveArray _.map(@values, filter)
    
    @bind "splice", (startIndex, amount, newValues...) =>
            
      # Find all moved values 
      movedValues = @values.slice(startIndex + amount + 1)
      
      newValues = newValues.concat(movedValues)
      newLiveValues = wrap(startIndex, newValues)
      amount += movedValues.length
      
      map.splice.apply map, [startIndex, amount].concat(_.map(newValues, filter))
    
    map
    
  
