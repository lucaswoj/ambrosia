Ambrosia = window?.Ambrosia || module.exports
{ _ } = Ambrosia

class Ambrosia.Model extends Ambrosia.Eventable
  
  set: (attributes) ->
    
    if arguments.length == 1
      [attributes] = arguments
      for key, value of attributes
        @[key].set(value)
    else if arguments.length == 2
      [key, value] = arguments
      @[key].set(value)