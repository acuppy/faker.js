(function() {
  var $, Faker;

  $ = jQuery;

  Faker = {};

  Faker.Base = {
    config: {},
    reset: function() {
      this.configure({});
    },
    configure: function(configs) {
      var baseConfig;
      if (!$.isPlainObject(configs)) {
        $.error("Hash expected -- received " + ($.type(configs)));
      }
      baseConfig = {
        locale: 'en'
      };
      this.config = $.extend(true, {}, baseConfig, configs);
    },
    extend: function(extension) {
      return $.extend(true, {}, this, extension || {});
    }
  };

  Faker = $.extend(true, {}, Faker.Base);

  Faker.init = Faker.reset;

  Faker.Lorem = Faker.extend({
    word: function() {
      return Faker.Locale.sample("lorem.words");
    },
    words: function(qty) {
      if (!$.isNumeric(qty)) $.error("Quantity must be a valid integer");
      return Faker.Locale.sample("lorem.words", qty);
    },
    characters: function(qty, as_array) {
      var arr;
      if (!$.isNumeric(qty)) $.error("Quantity must be a valid integer");
      arr = Faker.Locale.sample("lorem.characters", qty);
      if (as_array === true) {
        return arr;
      } else {
        return arr.join('');
      }
    },
    sentence: function(options) {
      var arr, opt, sentence;
      if ($.isNumeric(options)) {
        options = {
          length: options
        };
      }
      opt = $.extend({
        length: 10,
        startWithCapital: true,
        endWithPeriod: true
      }, options);
      arr = this.words(opt.length);
      if (opt.startWithCapital === true) {
        arr[0] = "" + (arr[0].charAt(0).toUpperCase()) + (arr[0].slice(1));
      }
      sentence = arr.join(' ');
      if (opt.endWithPeriod === true) sentence += '.';
      return sentence;
    },
    sentences: function(qty) {
      var args, as_array, i, options, sentences;
      if (!$.isNumeric(qty)) $.error("Quantity must be a valid integer");
      args = Array.prototype.slice.call(arguments, 1);
      options = {};
      as_array = false;
      sentences = new Array();
      if (args.length > 0 && $.type(args[args.length - 1]) === 'boolean') {
        as_array = args[args.length - 1];
      }
      if ($.isArray(args) && args.length > 0 && $.isPlainObject(args[0])) {
        $.extend(options, args[0]);
      }
      for (i = 0; 0 <= qty ? i < qty : i > qty; 0 <= qty ? i++ : i--) {
        sentences.push(this.sentence(options));
      }
      if (as_array === true) {
        return sentences;
      } else {
        return sentences.join(' ');
      }
    },
    paragraph: function(sentences, options) {
      if (sentences == null) sentences = 3;
      if (options == null) options = {};
      if (!$.isNumeric(sentences)) {
        $.error("First argument must be a valid integer");
      }
      return this.sentences(sentences, options);
    },
    paragraphs: function(qty) {
      var args, as_array, i, options, paragraphs;
      if (!$.isNumeric(qty)) $.error("Quantity must be a valid integer");
      args = Array.prototype.slice.call(arguments, 1);
      options = {};
      as_array = false;
      paragraphs = new Array();
      if (args.length > 0 && $.type(args[args.length - 1]) === 'boolean') {
        as_array = args[args.length - 1];
      }
      if ($.isArray(args && args.length > 0 && $.isPlainObject(args[0]))) {
        $.extend(options, args[0]);
      }
      for (i = 0; 0 <= qty ? i < qty : i > qty; 0 <= qty ? i++ : i--) {
        paragraphs.push(this.paragraph(3, options));
      }
      if (as_array === true) {
        return paragraphs;
      } else {
        return paragraphs.join(' ');
      }
    }
  });

  Faker.Name = Faker.extend({
    full_name: function() {
      var name;
      name = new Array();
      if (Faker.Util.Random.bool()) name.push(this.prefix());
      name.push(this.first_name());
      name.push(this.last_name());
      if (Faker.Util.Random.bool()) name.push(this.suffix());
      return name.join(' ');
    },
    prefix: function() {
      return Faker.Locale.sample('name.prefix');
    },
    first_name: function() {
      return Faker.Locale.sample('name.first_name');
    },
    last_name: function() {
      return Faker.Locale.sample('name.last_name');
    },
    suffix: function() {
      return Faker.Locale.sample('name.suffix');
    },
    title: function() {
      var title;
      title = new Array();
      title.push(Faker.Locale.sample('name.title.descriptor'));
      title.push(Faker.Locale.sample('name.title.level'));
      title.push(Faker.Locale.sample('name.title.job'));
      return title.join(' ');
    }
  });

  Faker.Company = Faker.extend({
    name: function() {
      return Faker.Util.interpret(Faker.Locale.sample("company.name"));
    },
    suffix: function() {
      return Faker.Locale.sample("company.suffix");
    },
    catch_phrase: function() {
      return $.map(Faker.Locale.collection("company.buzzwords"), function(elm, i) {
        return Faker.Util.Random.sample(elm);
      }).join(' ');
    },
    bs: function() {
      return $.map(Faker.Locale.collection("company.bs"), function(elm, i) {
        return Faker.Util.Random.sample(elm);
      }).join(' ');
    }
  });

  Faker.Internet = Faker.extend({
    email: function() {
      return [this.user_name(), this.domain_name()].join('@');
    },
    free_email: function() {
      return [this.user_name(), Faker.Locale.sample('internet.free_email')].join('@');
    },
    safe_email: function() {
      return [this.user_name(), "example." + (Faker.Util.Random.sample(['com', 'net', 'org']))].join('@');
    },
    user_name: function() {
      var samples;
      samples = [
        (function() {
          return Faker.Name.first_name();
        }), (function() {
          return $.map([Faker.Name.first_name(), Faker.Name.last_name()], function(elm, index) {
            return elm.replace(/\W/, '');
          }).join('_').toLowerCase();
        })
      ];
      return Faker.Util.fix_umlauts(Faker.Util.Random.sample(samples).call());
    },
    domain_name: function() {
      return [Faker.Util.fix_umlauts(this.domain_word()), this.domain_suffix()].join('.');
    },
    domain_word: function() {
      return Faker.Company.name().split(' ')[0].replace(/\W/, '').toLowerCase();
    },
    domain_suffix: function() {
      return Faker.Locale.sample('internet.domain_suffix');
    }
  });

  Faker.Util = {
    isBlank: function(object) {
      return ($.isPlainObject(object) && $.isEmptyObject(object)) || ($.isArray(object) && object.length === 0) || ($.type(object) === "string" && $.trim(object) === "") || (!object);
    },
    isPresent: function() {
      return !this.isBlank.apply(this, arguments);
    },
    interpret: function(raw) {
      var blocksToInterpret;
      blocksToInterpret = raw.match(/#{([a-zA-Z\.\-\_]+)}/gi);
      $.each(blocksToInterpret, function(index, elm) {
        var key;
        key = elm.replace(/[#{}\s]/gi, '');
        if (key.match(/^(?:(?:[a-zA-Z\-\_]+)\.?)+[a-zA-Z]+$/)) {
          return raw = raw.replace(elm, Faker.Locale.sample(key));
        }
      });
      return raw;
    },
    fix_umlauts: function(string) {
      string = string.replace("ä", 'ae');
      string = string.replace("ö", 'oe');
      string = string.replace("ü", 'ue');
      string = string.replace("ß", 'ss');
      return string;
    }
  };

  Faker.Util.Random = {
    bool: function() {
      return (Math.floor(Math.random() * 11) % 2) === 1;
    },
    sample: function(collection, size) {
      var i, index, shuffled, temp;
      shuffled = collection.slice(0);
      i = collection.length;
      if (size == null) size = 1;
      while (i--) {
        index = Math.floor(i * Math.random());
        temp = shuffled[index];
        shuffled[index] = shuffled[i];
        shuffled[i] = temp;
      }
      if (size > 1) {
        return shuffled.slice(0, size);
      } else {
        return shuffled.slice(0, 1)[0];
      }
    }
  };

  Faker.Locale = {
    sample: function(key, size) {
      var collection;
      collection = this.collection(key);
      return Faker.Util.Random.sample(collection, size);
    },
    collection: function(key) {
      var arrPath, collection, i, _ref;
      collection = Faker.Locales[Faker.config.locale];
      arrPath = key.split(".");
      for (i = 0, _ref = arrPath.length; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
        collection = collection[arrPath[i]];
      }
      if (Faker.Util.isBlank(collection)) {
        $.error("Unknown key: \"" + (key.toString()) + "\" -- you may need to scope it to the proper locale library (ex: name.first_name)");
      }
      return collection;
    },
    register: function(id, collection) {
      Faker.Locales[id] = collection;
    },
    extend: function() {
      var _base;
      if ((_base = Faker.Locales)[id] == null) _base[id] = {};
      return $.extend(true, Faker.Locales[id], collection);
    }
  };

  Faker.Locales = {};

  Faker.init();

  window.Faker = Faker;

  $.fn.faker = function() {
    return this.each(function() {});
  };

}).call(this);
