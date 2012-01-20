Ambrosia = window?.Ambrosia || module.exports
{ _ } = Ambrosia

class Ambrosia.LiveArray extends Ambrosia.Live
  
  constructor: (values = []) ->
    super
    @values = []
    @length = new Ambrosia.LiveValue(@values.length)
    @set(values)
  
  set: ->
    
    if arguments.length == 2
      values = {}
      values[arguments[0]] = arguments[1]
    else if arguments.length == 1
      values = arguments[0]

    @triggerAround "set", ->
      @splice 0, @length.get()
      if values instanceof Ambrosia.LiveArray
        refresh = (start, amount, values...) =>
          @splice.apply(@, [start, amount].concat(values))
        values.bindNowSplice(refresh)
        @bindOnce("beforeSet", -> values.unbind("change", refresh))
      else if _.isArray(arguments) or _.isObject(arguments)
        for index, value of values
          @splice(parseInt(index, 10), 1, value)
      
  get: (index) -> 
    @values[index]  
  
  flatten: -> @values

  push: (values...) ->
    @splice.apply @, [@values.length, 0].concat(values)

  pop: ->
    @splice @values.length - 1, 1

  unshift: (values...) -> 
    @splice.apply @, [0, 0].concat(values)

  shift: -> @splice 0, 1
    
  refreshLength: ->
    @length.set @values.length

  splice: (startIndex, amount, values...) ->
        
    args = arguments
    
    @triggerAround "change", =>
      @triggerAround "splice", args, =>

        _.times amount, =>
          value = @values[startIndex]
          @triggerAround "remove", [value, startIndex], =>
            @values.splice(startIndex, 1)
            @refreshLength()

        for value, offset in values
          index = startIndex + offset
          @triggerAround "add", [value, index], =>
            @values.splice(index, 0, value)
            @refreshLength()
            
  bindNowSplice: (listener) ->
    @bindNow("splice", [0, 0].concat(@values), listener)
          
  liveMap: (filter) ->
    
    map = new Ambrosia.LiveArray _.map(@values, filter)
    
    @bind "splice", (index, amount, values...) =>
      spliceArguments = [index, amount].concat(_.map(values, filter))
      map.splice.apply map, spliceArguments
    
    map
    
  
