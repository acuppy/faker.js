(function($, window){

  window.Faker = {}

  Faker.Base = {
    config: {},

    reset: function(){
      this.configure({});
    },

    configure: function(configs){
      if ( ! $.isPlainObject(configs) ) $.error("Hash expected -- received "+ $.type(configs));

      var baseConfig = {
        locale: 'en'
      }

      this.config = $.extend(true, {}, baseConfig, configs);
    },

    extend: function(extension){
      return $.extend(true, {}, this, extension || {});
    }
  }

  // rebase the Faker object on the Base object
  Faker = $.extend(true, {}, Faker.Base);
  // alias the init method to reset for now
  Faker.init = Faker.reset;

  Faker.Lorem = Faker.extend({
    word: function(){
      return Faker.Locale.sample("lorem.words")[0];
    },

    words: function(qty){
      if( ! $.isNumeric(qty) ) $.error("Quantity must be a valid integer");
      return Faker.Locale.sample("lorem.words", qty);
    },

    characters: function(qty, as_array){
      if( ! $.isNumeric(qty) ) $.error("Quantity must be a valid integer");
      var arr = Faker.Locale.sample("lorem.characters", qty);
      return as_array === true ? arr : arr.join('');
    },

    sentence: function(options){

      if( $.isNumeric(options) ){
        options = { length: options }
      }

      var opt = $.extend({
        length: 10,
        startWithCapital: true,
        endWithPeriod: true
      }, options);

      var arr = this.words(opt.length);
      if(opt.startWithCapital === true) arr[0] = arr[0].charAt(0).toUpperCase() + arr[0].slice(1);

      var sentence = arr.join(' ');
      if(opt.endWithPeriod === true) sentence += '.'

      return sentence;
    },

    sentences: function(qty){
      if( ! $.isNumeric(qty) ) $.error("Quantity must be a valid integer");

      var args      = Array.prototype.slice.call(arguments, 1);
      var options   = {};
      var as_array  = false;
      var sentences = new Array();

      if( args.length > 0 && typeof args[args.length - 1] == 'boolean') 
        as_array = args[args.length - 1];

      if( $.isArray(args) && args.length > 0 && $.isPlainObject(args[0]) ) 
        $.extend(options, args[0]);

      for (var i = 0; i < qty; i++) {
        sentences.push(this.sentence(options));
      };

      return as_array === true ? sentences : sentences.join(' ') 
    },

    paragraph: function(sentences, options){
      var sentences = sentences || 3;
      var options   = options   || {};

      if( ! $.isNumeric(sentences) ) $.error("First argument must be a valid integer");

      return this.sentences(sentences, options);
    },

    paragraphs: function(qty){
      if( ! $.isNumeric(qty) ) $.error("Quantity must be a valid integer");

      var args      = Array.prototype.slice.call(arguments, 1);
      var options   = {};
      var as_array  = false;
      var paragraphs = new Array();

      if( args.length > 0 && typeof args[args.length - 1] == 'boolean') 
        as_array = args[args.length - 1];

      if( $.isArray(args) && args.length > 0 && $.isPlainObject(args[0]) ) 
        $.extend(options, args[0]);

      for (var i = 0; i < qty; i++) {
        paragraphs.push(this.paragraph(3, options));
      };

      return as_array === true ? paragraphs : paragraphs.join(' ');
    }
  });

  Faker.Name = Faker.extend({
    full_name: function(){
      var name = new Array();
      
      if( Faker.Util.Random.bool() ){
        name.push(this.prefix());
      }
      
      name.push(this.first_name());
      name.push(this.last_name());
      
      if( Faker.Util.Random.bool() ){
        name.push(this.suffix());
      }

      return name.join(' ');
    },

    prefix: function(){
      return Faker.Locale.sample('name.prefix');
    },

    first_name: function(){
      return Faker.Locale.sample('name.first_name');
    },

    last_name: function(){
      return Faker.Locale.sample('name.last_name');
    },

    suffix: function(){
      return Faker.Locale.sample('name.suffix');
    },

    title: function(){
      var title = new Array();
      title.push(Faker.Locale.sample('name.title.descriptor'));
      title.push(Faker.Locale.sample('name.title.level'));
      title.push(Faker.Locale.sample('name.title.job'));
      return title.join(' ');
    }   
  });

  Faker.Company = Faker.extend({
    name: function(){
      return Faker.Util.interpret(Faker.Locale.sample("company.name")[0]);
    },

    suffix: function(){
      return Faker.Locale.sample("company.suffix")[0];
    },

    catch_phrase: function(){
      return $.map(Faker.Locale.collection("company.buzzwords"), function(elm, i){
        return Faker.Util.Random.sample(elm);
      }).join(' ');
    },

    bs: function(){
      return $.map(Faker.Locale.collection("company.bs"), function(elm, i){
        return Faker.Util.Random.sample(elm);
      }).join(' ');
    }
  });

  Faker.Util = {
    isBlank: function(object) {
      return (
        ($.isPlainObject(object) && $.isEmptyObject(object)) ||
        ($.isArray(object) && object.length == 0) ||
        (typeof(object) == "string" && $.trim(object) === "") ||
        (!object)
      );
    },

    isPresent: function(){
     return !this.isBlank.apply(this, arguments);
    },

    interpret: function(raw){
      var blocksToInterpret = raw.match(/#{([a-zA-Z\.\-\_]+)}/gi);
      
      $.each(blocksToInterpret, function(index, elm){
        var key = elm.replace(/[#{}\s]/gi, '');
        // "lorem.name" not "{lorem.name}" or "lorem.name."
        if( key.match(/^(?:(?:[a-zA-Z\-\_]+)\.?)+[a-zA-Z]+$/) ){
          raw = raw.replace(elm, Faker.Locale.sample(key));
        }
      });

      return raw;
    }
  };

  Faker.Util.Random = {
    bool: function(){
      return (Math.floor(Math.random()*11) % 2) == 1
    },

    sample: function(collection, size){
      var shuffled = collection.slice(0);
      var i = collection.length;
      var temp;
      var index;

      while (i--) {
        index = Math.floor(i * Math.random());
        temp = shuffled[index];
        shuffled[index] = shuffled[i];
        shuffled[i] = temp;
      }

      return shuffled.slice(0, size || 1);
    }
  }

  Faker.Locale = {

    sample: function(key, size){
      var collection = this.collection(key);
      return Faker.Util.Random.sample(collection, size);
    },

    collection: function(key){

      var collection = Faker.Locales[Faker.config.locale];
      var arrPath = key.split(".");

      for (var i = 0; i < arrPath.length; i++) {
        collection = collection[arrPath[i]];
      };

      if( Faker.Util.isBlank(collection) ) $.error('Unknown key: "'+ key.toString() +'" -- you may need to scope it to the proper locale library (ex: name.first_name)');

      return collection;
    },

    register: function(id, collection){
      Faker.Locales[id] = collection;
    },

    extend: function(){
      if( ! Faker.Locales[id] ) Faker.Locales[id] = {};
      $.extend(true, Faker.Locales[id], collection);
    }
  };

  Faker.Locales = {};

  Faker.init();

  $.fn.faker = function(){
    return this.each(function(){
      
    });
  };

})(jQuery, window);