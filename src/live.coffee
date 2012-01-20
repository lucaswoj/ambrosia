Ambrosia = window?.Ambrosia || module.exports
{ _ } = Ambrosia

class Ambrosia.Live extends Ambrosia.Eventable
  
  @_depth: 0
  
  @dependencies: (action) ->

    depth = ++Live._depth
    dependencies = []
    
    add = -> dependencies.push(@) if Live._depth == depth
    
    Ambrosia.Live.instanceBind get: add
    action()
    Ambrosia.Live.instanceUnbind get: add
    
    Live._depth--
    
    dependencies