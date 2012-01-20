Ambrosia = window?.Ambrosia || module.exports
{ Zepto, $, _ } = Ambrosia

class Ambrosia.TemplateView extends Ambrosia.View
    
  constructor: (options = {}) ->
    { @context, @template } = options
    super _.extend options,
      html: new Ambrosia.LiveValue => @template(@context)