Ambrosia = window?.Ambrosia || module.exports
{ _ } = Ambrosia

class Ambrosia.Live extends Ambrosia.Eventable
  
  constructor: ->
    super
  
  @_depth: 0
  
  @dependencies: (action) ->

    depth = ++Live._depth
    dependencies = []
    
    add = -> dependencies.push @ if Live._depth == depth
    
    Ambrosia.LiveValue.instanceBind get: add
    action()
    Ambrosia.LiveValue.instanceUnbind get: add
    
    Live._depth--
    
    dependencies