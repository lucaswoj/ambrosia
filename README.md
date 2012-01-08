# Ambrosia

## Introduction

## API Reference

### Ambrosia

#### Properties

`Ambrosia.node`: `true` if we're running in a CommonJS environment, `false` otherwise

`Ambrosia.browser`: `true` if we're running in the browser, `false` otherwise

### Utility Methods

`_.capitalize(string)`: Make the first letter of a string uppercase. For example, _.capitalize

`_.mapObject(object, filter)`: Works like `_.map` but preserves the keys of the source object. For example, 

  scientists = 
    richard: "feynman"
    albert: "einstein"
  
  _.mapObject fruits, (last, first) -> "#{first} #{last}"

would return

  richard: "richard feynman"
  albert: "albert einstein"

### Ambrosia.Eventable

#### Methods

`bind(event, listener): Run `listener` whenever `event` occurs. Method can also be called with an object of `event: listener` pairs.

`bindOnce(name, listener)`: Run `listener` the next time `event` occurs and then unbind it. Method can also be called with an object of `event: listener` pairs.

`bindNow(name, listener)`: Run `listener` right now and then whenever `event` occurs. This is useful for `LiveValue` `change` events such as

  color.bindNow "change", -> profile.css
    backgroundColor: color.get()
    
Method can also be called with an object of `event: listener` pairs.

`unbind(event, listener)`: Prevent `listener` from being run on future occurrences of `event`. Method can also be called with an object of `event: listener` pairs.

`unbind(event)`: Unbind all listeners for `event`

`unbind()`: Unbind all listeners for all events

`trigger(name, arguments...)`:

`triggerAround(name, arguments..., action)`:

#### Class Methods

`instanceBind(name, listener)` or `instanceBind(events)`

`instanceBindOnce(name, listener)` or `instanceBindOnce(events)`

`instanceUnbind(name, listener)` or `instanceUnbind(events)`

### Ambrosia.LiveValue

#### Methods

`get()`

`set(getter)`

#### Events

`get` - When the attribute's value is read

`beforeChange` - Just before the attribute's value changes

`change` - When the attribute's value changes

`afterChange` - Immediately after the attribute's value changes

### Ambrosia.View
