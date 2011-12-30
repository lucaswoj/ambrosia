# Ambrosia

## Introduction

## API Reference

### Utility Methods

`_.mapObject(object, filter)`

`_.capitalize(string)`

### Ambrosia.Eventable

#### Class Methods

`instanceBind(name, listener)` or `instanceBind(events)`

`instanceBindOnce(name, listener)` or `instanceBindOnce(events)`

`instanceUnbind(name, listener)` or `instanceUnbind(events)`

#### Methods

`bind(name, listener)` or `bind(events)`

`bindOnce(name, listener)` or `bindOnce(events)`

`unbind(name, listener)` or `unbind(events)`

`trigger(name, arguments...)`

`triggerAround(name, arguments..., action)`

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
