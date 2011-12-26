_.mixin
  
  mapObject: (input, filter) ->
    output = {}
    output[key] = filter(value, key) for key, value of input
    output
    
  capitalize: (string) ->
    if string.length
      string[0].toUpperCase() + string.slice(1)
    else
      ""