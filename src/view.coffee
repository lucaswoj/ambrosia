Ambrosia = window?.Ambrosia || module.exports
{ Zepto, $, _ } = Ambrosia

class Ambrosia.View extends Ambrosia.Eventable
  
  tag: "div"
  
  constructor: (options = {}) ->
    
    super
    
    { element, id, text, html } = options
    
    if !element?
      @$element = $("<#{@tag}>")
      @element = @$element[0]
    else if _.isElement(element)
      @element = element
      @$element = $(@element)
    else
      @$element = element
      @element = element[0]
  
    @text = new Ambrosia.LiveValue
    @html = new Ambrosia.LiveValue
    
    @text.bind "change", => @$element.text(@text.get())
    @html.bind "change", => @$element.html(@html.get())
    
    @text.set(text) if text?
    @html.set(html) if html?
        
    @id = new Ambrosia.LiveValue id || @$element.attr("id") || _.uniqueId("ambrosia")
    @id.bindNow "change", => @$element.attr("id", @id.get())
          
    @addClasses(options.classes) if options.classes
      
  # ## CSS Manipulation
  
  addStyles: (styles) ->
    for key, value in styles
      @addStyle(key, value)
  
  addStyle: (key, value) ->
    @styles[key] = new Ambrosia.LiveValue(value)
    @styles[key].bindNow "change", ->
      @$element.setStyle(key, @styles[key].get())
  
  # ## Class Manipulation
  
  classes = {}
  
  addClasses: (values) ->
    @addClass value for value in values
    
  removeClasses: (values) ->
    @removeClass value for value in values
  
  addClass: (value) ->
    liveValue = new Ambrosia.LiveValue value
    classes[value] = liveValue
    liveValue.bind "beforeChange", =>
      @$element.removeClass liveValue.get()
    liveValue.bindNow "afterChange", =>
      @$element.addClass liveValue.get()
      
  removeClass: (value) ->
    liveValue = classes[value]
    @$element.removeClass value.get()
    value.unbind()    