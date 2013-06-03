(function($, window){

  window.Faker = {};

  Faker.Lorem  = {
    word: function(){
      return Faker.Locale.sample("lorem.words");
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
  };

  Faker.Name = {
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
      return Faker.Locale.sample('name.prefix')
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
  };

  Faker.Company = {

  }

  Faker.Util = {
    Random: {
      bool: function(){
        return (Math.floor(Math.random()*11) % 2) == 1
      }
    },

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
    }
  };

  Faker.Locale = {
    sample: function(key, size){

      var collection = this.getByKey(key);
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
    },

    getByKey: function(key){
      var collection = Faker.Locales.en;
      var arrPath = key.split(".");

      for (var i = 0; i < arrPath.length; i++) {
        collection = collection[arrPath[i]];
      };

      return collection;
    },

    register: function(id, collection){
      Faker.Locales[id] = collection;
    },

    extend: function(){
      // if( $.type( Faker.Locales[id] ) === "undefined" ) Faker.Locales[id] = {};
      // $.extend(true, Faker.Locales[id], collection);
    }
  };

  Faker.Locales = {};

  $.fn.faker = function(){};

})(jQuery, window);