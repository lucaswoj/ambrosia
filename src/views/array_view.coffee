Ambrosia = window?.Ambrosia || module.exports
{ Zepto, $, _ } = Ambrosia

class Ambrosia.ArrayView extends Ambrosia.View
  
  constructor: (options = {}) ->
    
    super options
    
    @children = new Ambrosia.LiveArray(options.children)
    @childView = options.childView
    
    @childViews = @children.liveMap (model) => new @childView(model: model, parentView: @)
    @childElements = @childViews.liveMap (view) => view.$element
    
    @childElements.bindNowSplice (start, amount, elements...) =>
      @$element.children().slice(start, start + amount).remove()
      if start == 0
        @$element.prepend(element) for element in elements.reverse()
      else
        $before = @$element.children().eq(start - 1)
        $before.after(element) for element in elements.reverse()