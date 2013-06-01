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
      debugger
      var args      = arguments; //Array.prototype.slice.call(arguments).unshift();
      var options   = {};
      var sentences = new Array();

      if( $.isArray(args) && args.length > 0 && $.isObject(args[1]) ) $.extend(options, args[1]);

      for (var i = 0; i < qty; i++) {
        sentences.push(this.sentence(options));
      };

      return options['as_array'] === true ? sentences : sentences.join(' ') 
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
      var collection = Faker.Locales["en"]; // Faker.Locale[Faker.config.locale];
      var arrPath = key.split(".");

      for (var i = 0; i < arrPath.length; i++) {
        collection = collection[arrPath[i]];
      };

      return collection;
    }
  };

  Faker.Locales = {
    en: {
      lorem: {
        characters: ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"],
        words: ["alias", "consequatur", "aut", "perferendis", "sit", "voluptatem", "accusantium", "doloremque", "aperiam", "eaque", "ipsa", "quae", "ab", "illo", "inventore", "veritatis", "et", "quasi", "architecto", "beatae", "vitae", "dicta", "sunt", "explicabo", "aspernatur", "aut", "odit", "aut", "fugit", "sed", "quia", "consequuntur", "magni", "dolores", "eos", "qui", "ratione", "voluptatem", "sequi", "nesciunt", "neque", "dolorem", "ipsum", "quia", "dolor", "sit", "amet", "consectetur", "adipisci", "velit", "sed", "quia", "non", "numquam", "eius", "modi", "tempora", "incidunt", "ut", "labore", "et", "dolore", "magnam", "aliquam", "quaerat", "voluptatem", "ut", "enim", "ad", "minima", "veniam", "quis", "nostrum", "exercitationem", "ullam", "corporis", "nemo", "enim", "ipsam", "voluptatem", "quia", "voluptas", "sit", "suscipit", "laboriosam", "nisi", "ut", "aliquid", "ex", "ea", "commodi", "consequatur", "quis", "autem", "vel", "eum", "iure", "reprehenderit", "qui", "in", "ea", "voluptate", "velit", "esse", "quam", "nihil", "molestiae", "et", "iusto", "odio", "dignissimos", "ducimus", "qui", "blanditiis", "praesentium", "laudantium", "totam", "rem", "volupttum", "deleniti", "atque", "corrupti", "quos", "dolores", "et", "quas", "molestias", "excepturi", "sint", "occaecati", "cupiditate", "non", "provident", "sed", "ut", "perspiciatis", "unde", "omnis", "iste", "natus", "error", "similique", "sunt", "in", "culpa", "qui", "officia", "deserunt", "mollitia", "animi", "id", "est", "laborum", "et", "dolorum", "fuga", "et", "harum", "quidem", "rerum", "facilis", "est", "et", "expedita", "distinctio", "nam", "libero", "tempore", "cum", "soluta", "nobis", "est", "eligendi", "optio", "cumque", "nihil", "impedit", "quo", "porro", "quisquam", "est", "qui", "minus", "id", "quod", "maxime", "placeat", "facere", "possimus", "omnis", "voluptas", "assumenda", "est", "omnis", "dolor", "repellendus", "temporibus", "autem", "quibusdam", "et", "aut", "consequatur", "vel", "illum", "qui", "dolorem", "eum", "fugiat", "quo", "voluptas", "nulla", "pariatur", "at", "vero", "eos", "et", "accusamus", "officiis", "debitis", "aut", "rerum", "necessitatibus", "saepe", "eveniet", "ut", "et", "voluptates", "repudiandae", "sint", "et", "molestiae", "non", "recusandae", "itaque", "earum", "rerum", "hic", "tenetur", "a", "sapiente", "delectus", "ut", "aut", "reiciendis", "voluptatibus", "maiores", "doloribus", "asperiores", "repellat"]
      }
    }
  };

  $.fn.faker = function(){

  }

})(jQuery, window);