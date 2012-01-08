Ambrosia = window?.Ambrosia || module.exports
{ Zepto, $, _ } = Ambrosia

class Ambrosia.HandlebarsView extends Ambrosia.TemplateView
    
  constructor: (options = {}) ->
    options.template = Ambrosia.Handlebars.compile(options.source)
    super(options)