class Ambrosia.View
  
  constructor: (options) ->
    
    @element = options.element || options.$element[0]
    @$element = options.$element || $ options.element
    
    if options.text
      @text = new Ambrosia.Attribute options.text
      @$element.text(@text.get())
      @text.bind "change", => @$element.text(@text.get())
    
    else if options.html
      @html = new Ambrosia.Attribute options.html
      @$element.html(@html.get())
      @html.bind "change", => @$element.html(@html.get())