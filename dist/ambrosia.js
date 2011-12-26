(function() {
  var Ambrosia, _;

  Ambrosia = {};

  if ((typeof require !== "undefined" && require !== null) && (typeof module !== "undefined" && module !== null)) {
    module.exports = global.Ambrosia = Ambrosia;
    Ambrosia.util = _ = global._ = require("underscore");
  } else if (typeof window !== "undefined" && window !== null) {
    window.Ambrosia = Ambrosia;
    Ambrosia.util = _ = window._;
  }

}).call(this);
(function() {

  _.mixin({
    mapObject: function(input, filter) {
      var key, output, value;
      output = {};
      for (key in input) {
        value = input[key];
        output[key] = filter(value, key);
      }
      return output;
    },
    capitalize: function(string) {
      if (string.length) {
        return string[0].toUpperCase() + string.slice(1);
      } else {
        return "";
      }
    }
  });

}).call(this);
(function() {
  var __slice = Array.prototype.slice;

  Ambrosia.Eventable = (function() {
    var argumentsToObject;

    Eventable.events = {};

    Eventable.instanceBind = function() {
      var event, events, listener, name, _base, _base2, _results;
      events = argumentsToObject(arguments);
      _results = [];
      for (name in events) {
        listener = events[name];
        event = (_base = ((_base2 = Eventable.events)[this] || (_base2[this] = {})))[name] || (_base[name] = []);
        _results.push(event.push(listener));
      }
      return _results;
    };

    Eventable.instanceBindOnce = function() {
      var events,
        _this = this;
      events = argumentsToObject(arguments);
      events = _.mapObject(events, function(listener) {
        return function() {
          _this.instanceUnbind(events);
          return listener();
        };
      });
      return this.instanceBind(events);
    };

    Eventable.instanceUnbind = function() {
      var events, listener, name, _results;
      events = argumentsToObject(arguments);
      _results = [];
      for (name in events) {
        listener = events[name];
        _results.push(this.events[this][name] = _.without(this.events[this][name], listener));
      }
      return _results;
    };

    function Eventable() {
      this.events = {};
    }

    Eventable.prototype.bind = function() {
      var event, events, listener, name, _base, _results;
      events = argumentsToObject(arguments);
      _results = [];
      for (name in events) {
        listener = events[name];
        event = (_base = this.events)[name] || (_base[name] = []);
        _results.push(event.push(listener));
      }
      return _results;
    };

    Eventable.prototype.bindOnce = function() {
      var events;
      events = argumentsToObject(arguments);
      events = _.mapObject(events, function(listener) {
        return function() {
          this.unbind(events);
          return listener();
        };
      });
      return this.bind(events);
    };

    Eventable.prototype.unbind = function() {
      var events, listener, name, _results;
      events = argumentsToObject(arguments);
      _results = [];
      for (name in events) {
        listener = events[name];
        _results.push(this.events[name] = _.without(this.events[name], listener));
      }
      return _results;
    };

    Eventable.prototype.triggerAround = function() {
      var action, args, name, _i;
      name = arguments[0], args = 3 <= arguments.length ? __slice.call(arguments, 1, _i = arguments.length - 1) : (_i = 1, []), action = arguments[_i++];
      this.trigger.apply(this, ["before" + (_.capitalize(name))].concat(args));
      action();
      this.trigger.apply(this, [name].concat(args));
      return this.trigger.apply(this, ["after" + (_.capitalize(name))].concat(args));
    };

    Eventable.prototype.trigger = function() {
      var ancestor, args, listener, name, _i, _j, _len, _len2, _ref, _ref2, _ref3, _ref4, _results;
      name = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      ancestor = this.constructor;
      while (ancestor) {
        if (((_ref = Eventable.events[ancestor]) != null ? _ref[name] : void 0) != null) {
          _ref2 = Eventable.events[ancestor][name];
          for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
            listener = _ref2[_i];
            listener.apply(this, args);
          }
        }
        ancestor = (_ref3 = ancestor.__super__) != null ? _ref3.constructor : void 0;
      }
      if (this.events[name] != null) {
        _ref4 = this.events[name];
        _results = [];
        for (_j = 0, _len2 = _ref4.length; _j < _len2; _j++) {
          listener = _ref4[_j];
          _results.push(listener.apply(this, args));
        }
        return _results;
      }
    };

    argumentsToObject = function(args) {
      var events;
      if (args.length === 2) {
        events = {};
        events[args[0]] = args[1];
        return events;
      } else if (args.length === 1) {
        return args[0];
      }
    };

    return Eventable;

  })();

}).call(this);
(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  Ambrosia.Attribute = (function(_super) {

    __extends(Attribute, _super);

    function Attribute(getter) {
      Attribute.__super__.constructor.apply(this, arguments);
      this.dependencies = [];
      this.set(getter);
    }

    Attribute.prototype.get = function() {
      this.trigger("get", function() {});
      return this.value;
    };

    Attribute.prototype.set = function(getter) {
      if (getter == null) getter = function() {};
      if (_.isFunction(getter)) {
        this.getter = getter;
      } else if (getter instanceof Ambrosia.Attribute) {
        this.getter = function() {
          return getter.get();
        };
      } else {
        this.getter = function() {
          return getter;
        };
      }
      return this.refresh();
    };

    Attribute.prototype.refresh = function() {
      var add, dependencies, dependency, watch, _i, _len, _ref,
        _this = this;
      watch = function() {
        return _this.refresh();
      };
      _ref = this.dependencies;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        dependency = _ref[_i];
        dependency.unbind({
          change: watch
        });
      }
      this.dependencies = [];
      dependencies = this.dependencies;
      add = function() {
        dependencies.push(this);
        return this.bind({
          change: watch
        });
      };
      return this.triggerAround("change", function() {
        Ambrosia.Attribute.instanceBind({
          get: add
        });
        _this.value = _this.getter();
        return Ambrosia.Attribute.instanceUnbind({
          get: add
        });
      });
    };

    return Attribute;

  })(Ambrosia.Eventable);

}).call(this);
(function() {

  Ambrosia.View = (function() {

    function View(options) {
      var _this = this;
      this.element = options.element || options.$element[0];
      this.$element = options.$element || $(options.element);
      if (options.text) {
        this.text = new Ambrosia.Attribute(options.text);
        this.$element.text(this.text.get());
        this.text.bind("change", function() {
          return _this.$element.text(_this.text.get());
        });
      } else if (options.html) {
        this.html = new Ambrosia.Attribute(options.html);
        this.$element.html(this.html.get());
        this.html.bind("change", function() {
          return _this.$element.html(_this.html.get());
        });
      }
    }

    return View;

  })();

}).call(this);
