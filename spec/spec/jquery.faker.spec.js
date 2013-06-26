
describe("Faker", function() {
  it("binds to the window", function() {
    expect(Faker).toBeDefined();
  });

  describe("Faker.config", function() {
    describe("defaults", function() {
      beforeEach(function() {
        Faker.configure({});  
      });

      it("should have locale", function() {
        expect(Faker.config.locale).toEqual('en');
      });
    });
  });

  describe("#configure", function() {
    beforeEach(function() {
      Faker.configure({ locale: 'es' });
    });

    afterEach(function() {
      Faker.configure({});
    });

    it("should updated the Faker.config hash", function() {
      expect(Faker.config.locale).toEqual('es');
    });
  });

  describe("#reset", function() {
    beforeEach(function() {
      Faker.configure({ locale: 'es' });
      Faker.reset();
    });

    it("should updated the Faker.config hash", function() {
      expect(Faker.config.locale).toEqual('en');
    });
  });

  describe("#init", function() {
    beforeEach(function() {
      spyOn(Faker, 'configure').andCallThrough();
      Faker.init();
    });

    it("should call Faker.configure()", function() {
      expect(Faker.configure).toHaveBeenCalled();
    });
  });
  
  describe("Faker.Lorem", function() {
    
    it("binds to Faker", function() {
      expect(Faker.Lorem).toBeDefined();  
    });

    describe("#word", function() {
      it("returns a string", function() {
        expect($.type(Faker.Lorem.word())).toEqual('string');
      });

      it("returns a single word", function() {
        expect(Faker.Lorem.word()).toMatch(/^[a-zA-Z]+$/);
      });
    });

    describe("#words", function() {
      it("returns an array of words based on quantity", function() {
        expect( $.isArray(Faker.Lorem.words(3)) ).toBeTruthy();
      });

      it("throws an error when the quantity is not an integer", function() {
        expect(function(){ 
          Faker.Lorem.words('blah') 
        }).toThrow();
      });
    });

    describe("#characters", function() {
      it("returns a string of characters", function() {
        expect(Faker.Lorem.characters(16)).toMatch(/^[a-zA-Z0-9]{16}$/);
      });

      describe("as array", function() {
        it("returns an array of characters", function() {
          expect( $.isArray(Faker.Lorem.characters(16, true)) ).toBeTruthy();
        });
      });

      it("throws an error when the quantity is not an integer", function() {
        expect(function(){ 
          Faker.Lorem.characters('blah') 
        }).toThrow();
      });
    });

    describe("#sentence", function() {
      it("returns a string", function() {
        expect($.type(Faker.Lorem.sentence())).toEqual('string');
      });

      it("returns a string representation", function() {
        expect(Faker.Lorem.sentence()).toMatch(/^(?:(?:[a-zA-Z]+)\s?)+\.?$/);
      });

      describe("options", function() {
        describe("length", function() {
          it("iterpretes the first argument as length", function() {
            expect(Faker.Lorem.sentence(3)).toMatch(/^(?:(?:[a-zA-Z]+)\s?){3}\.?$/);
          });

          it("finds length from hash options", function() {
            expect(Faker.Lorem.sentence({
              length: 3 
            })).toMatch(/^(?:(?:[a-zA-Z]+)\s?){3}\.?$/);
          });
        });

        describe("startWithCapital", function() {
          it("returns a string that starts capitalized", function() {
            expect(Faker.Lorem.sentence()).toMatch(/^[^a-z](?:[a-zA-Z]+\s?)+\.?$/);
          });

          it("returns a string that does NOT start capitalized", function() {
            expect(Faker.Lorem.sentence({
              startWithCapital: false
            })).toMatch(/^[^A-Z](?:[a-zA-Z]+\s?)+\.?$/);
          });
        });

        describe("endWithPeriod", function() {
          it("returns a string that ends with a period", function() {
            expect(Faker.Lorem.sentence()).toMatch(/^(?:[a-zA-Z]+\s?)+\.?$/);
          });

          it("returns a string that does NOT end with a period", function() {
            expect(Faker.Lorem.sentence({
              endWithPeriod: false
            })).toMatch(/^(([a-zA-Z]+)\s?)+$/);
          });
        });
      });
    });

    describe("#sentences", function() {
      it("returns a string of multiple sentences", function() {
        expect(Faker.Lorem.sentences(3)).toMatch(/^(?:(?:\s?\w\s?)+\.){3}$/);
      });

      describe("as array", function() {
        it("returns an array of sentences", function() {
          expect( $.isArray(Faker.Lorem.sentences(3, true)) ).toBeTruthy();
        });
      });

      describe("with options for #sentence passed as the second argument", function() {
        var spyOnSentence;

        beforeEach(function() {
          spyOnSentence  = spyOn(Faker.Lorem, 'sentence');
          Faker.Lorem.sentences(3, { length: 5 });
        });

        it("should pass the options to #sentence", function() {
          expect(spyOnSentence).toHaveBeenCalledWith({ length: 5 });
        });
      });
    });

    describe("#paragraph", function() {
      var spyOnSentences;

      beforeEach(function() {
        spyOnSentences = spyOn(Faker.Lorem, 'sentences').andCallThrough();
      });

      it("calls #sentences", function() {
        Faker.Lorem.paragraph();
        expect(spyOnSentences).toHaveBeenCalledWith(3, {});
      });

      it("returns a string", function() {
        expect($.type(Faker.Lorem.paragraph())).toEqual('string');
      });

      it("returns a string of multiple sentences", function() {
        expect(Faker.Lorem.paragraph()).toMatch(/^(?:(?:\s?\w\s?)+\.){2,}$/);
      });

      it("returns a string of sentences matching first argument", function() {
        expect(Faker.Lorem.paragraph(2)).toMatch(/^(?:(?:\s?\w\s?)+\.){2}$/);
      });
    });

    describe("#paragraphs", function() {
      var spyOnParagraph;

      beforeEach(function() {
        spyOnParagraph = spyOn(Faker.Lorem, 'paragraph').andCallThrough();
      });

      it("calls #paragraph", function() {
        Faker.Lorem.paragraphs(3);
        expect(spyOnParagraph).toHaveBeenCalled();
      });

      describe("as array", function() {
        it("returns an array of paragraphs", function() {
          expect( $.isArray(Faker.Lorem.paragraphs(3, true)) ).toBeTruthy();
        });
      });
    });
  });

  describe("Faker.Name", function() {
    it("binds to Faker", function() {
      expect(Faker.Name).toBeDefined();
    });

    describe("#name", function() {
      var parts, name;

      beforeEach(function() {
        spyOn(Faker.Util.Random, 'bool').andReturn(true);
        parts = Faker.Name.full_name().split(' ');
        name  = Faker.Locales.en.name;
      });

      it("returns a fullname", function() {
        expect( $.inArray(parts[0], name.prefix ) ).toBeTruthy();
        expect( $.inArray(parts[1], name.first_name ) ).toBeTruthy();
        expect( $.inArray(parts[2], name.last_name ) ).toBeTruthy();
        expect( $.inArray(parts[3], name.suffix ) ).toBeTruthy();
      });
    });

    describe("#prefix", function() {
      it("returns a prefix", function() {
        expect( $.inArray(Faker.Name.prefix(), Faker.Locales.en.name.prefix)).toBeTruthy();
      });
    });

    describe("#first_name", function() {
      it("returns a first name", function() {
        expect( $.inArray(Faker.Name.first_name(), Faker.Locales.en.name.first_name)).toBeTruthy();
      });
    });

    describe("#last_name", function() {
      it("returns a last name", function() {
        expect( $.inArray(Faker.Name.last_name(), Faker.Locales.en.name.last_name)).toBeTruthy();
      });
    });

    describe("#suffix", function() {
      it("returns a suffix", function() {
        expect( $.inArray(Faker.Name.suffix(), Faker.Locales.en.name.suffix)).toBeTruthy();
      });
    });

    describe("#title", function() {
      var parts;

      beforeEach(function() {
        parts = Faker.Name.title().split(' ');  
      });

      it("returns a title", function() {
        expect( $.inArray(parts[0], Faker.Locales.en.name.title.descriptor)).toBeTruthy();
        expect( $.inArray(parts[1], Faker.Locales.en.name.title.level)).toBeTruthy();
        expect( $.inArray(parts[2], Faker.Locales.en.name.title.job)).toBeTruthy();
      });
    });
  });

  describe("Faker.Company", function() {
    it("binds to Faker", function() {
      expect(Faker.Company).toBeDefined();
    });

    describe("#name", function() {
      it("returns a string", function() {
        expect($.type(Faker.Company.name())).toEqual('string');
      });

      it("returns a name", function() {
        expect(Faker.Company.name()).toMatch(/^(?:[a-zA-Z,'\-]+\s?)+$/);
      });
    });

    describe("#suffix", function() {
      it("returns a string", function() {
        expect($.type(Faker.Company.suffix())).toEqual('string');
      });

      it("returns a suffix", function() {
        expect(Faker.Company.suffix()).toMatch(/^(?:[a-zA-Z]+\s?)+$/);
      });
    });

    describe("#catch_phrase", function() {
      it("returns a string", function() {
        expect($.type(Faker.Company.catch_phrase())).toEqual('string');
      });

      it("returns a sentence of values", function() {
        expect(Faker.Company.catch_phrase()).toMatch(/^(?:[a-zA-Z0-9\-\/,']+\s?)+$/);
      });
    });

    describe("#bs", function() {
      it("returns a string", function() {
        expect($.type(Faker.Company.bs())).toEqual('string');
      });

      it("returns a sentence of values", function() {
        expect(Faker.Company.bs()).toMatch(/^(?:[a-zA-Z0-9\-\/,']+\s?)+$/);
      });
    });
  });

  describe("Faker.Util", function() {
    it("binds to Faker", function() {
      expect(Faker.Util).toBeDefined();
    });

    describe("Random", function() {
      it("binds to Util", function() {
        expect(Faker.Util.Random).toBeDefined();
      });

      describe("#bool", function() {
        it("returns a bool", function() {
          expect( $.type(Faker.Util.Random.bool()) == 'boolean').toBeTruthy();
        });
      });
    });

    describe("#isBlank", function() {
      it("arrays", function() {
        expect(Faker.Util.isBlank([])).toBeTruthy();
        expect(Faker.Util.isBlank(['foo', 'bar'])).toBeFalsy();
      });

      it("strings", function() {
        expect(Faker.Util.isBlank('')).toBeTruthy();
        expect(Faker.Util.isBlank('foo bar')).toBeFalsy();
      });

      it("objects", function() {
        expect(Faker.Util.isBlank({})).toBeTruthy();
        expect(Faker.Util.isBlank({ foo: 'bar' })).toBeFalsy();
      });
    });

    describe("#isPresent", function() {
      it("arrays", function() {
        expect(Faker.Util.isPresent([])).toBeFalsy();
        expect(Faker.Util.isPresent(['foo', 'bar'])).toBeTruthy();
      });

      it("strings", function() {
        expect(Faker.Util.isPresent('')).toBeFalsy();
        expect(Faker.Util.isPresent('foo bar')).toBeTruthy();
      });

      it("objects", function() {
        expect(Faker.Util.isPresent({})).toBeFalsy();
        expect(Faker.Util.isPresent({ foo: 'bar' })).toBeTruthy();
      });
    });

    describe("#interpret", function() {
      beforeEach(function() {
        Faker.Locales.en = {
          name: {
            first_name: ["Aaliyah"],
            last_name:  ["Abbott"]
          },
          company: {
            suffix: ["Inc"]
          }
        }
      });

      it("returns a string with the proper injections", function() {
        var str = "#{name.first_name} - #{name.last_name} - #{company.suffix}";
        var exp = "Aaliyah - Abbott - Inc";
        expect(Faker.Util.interpret(str)).toEqual(exp);
      });
    });
  });

  describe("Faker.Locale", function() {
    it("binds to Faker", function() {
      expect(Faker.Locale).toBeDefined();
    });

    describe("#sample", function() {
      var collection = ["foo", "bar"];

      beforeEach(function() {
        spyOn(Faker.Locale, 'collection').andReturn(collection);
      });

      it("returns one of two", function() {
        expect( $.inArray(Faker.Locale.sample('foo.bar'), collection)).toBeTruthy();
      });
    });

    describe("#collection", function() {
      it("returns a collection from a locale based on the key", function() {
        pending();
      });
    });

    describe("#register", function() {
      var spyOnLocales;

      beforeEach(function() {
        spyOnLocales = spyOn(Faker.Locales, 'en');
        Faker.Locale.register('es', { name: ["jesus", "juan"] });
      });

      it("creates a new object instance with the collection", function() {
        expect(Faker.Locales.es).toBeDefined();
      });

      it("binds the collection to the Locale", function() {
        expect(Faker.Locales.es.name).toEqual(["jesus", "juan"])
      });
    });

    xdescribe("#extend", function() {
      beforeEach(function() {
        Faker.Locales.en = { foo: "bar", arr: ['stuff', 'things'] }
        var collection = { blah: 'blah', arr: ['blah'] }
        Faker.Locale.register('en', collection )
      });

      xit("extends the existing collection", function() {
        expect( Faker.Util.isPresent(Faker.Locales.en.arr['stuff']) ).toBeTruthy();
        expect( Faker.Util.isPresent(Faker.Locales.en.arr['blah']) ).toBeTruthy();
        expect( Faker.Locales.en.foo == "bar" ).toBeTruthy();
        expect( Faker.Locales.en.blah == "blah" ).toBeTruthy();
      });
    });
  });

  describe("Extensions", function() {
    describe("#extend", function() {
      beforeEach(function() {
        spyOn($, 'extend').andCallThrough();

        Faker.TestExtension = Faker.extend({
          custom_method: function(){ }
        });
      });

      it("should have the newly added extension methods", function() {
        expect(Faker.TestExtension.custom_method).toBeDefined();
      });

      it("should extend Faker.Extension.Base", function() {
        expect($.extend).toHaveBeenCalled();
      });

      describe("configs", function() {
        beforeEach(function() {
          Faker.configure({
            foo: 'bar'
          });

          Faker.TestExtension.configure({
            foo3: 'bar3'
          });
        });

        it("should not inherit the configs from Faker", function() {
          expect(Faker.config.foo).toBeDefined();
        });

        it("should not have extended the parent extension", function(){
          expect(Faker.config.foo2).not.toBeDefined()
        });

        it("should not inherit the configs from Faker", function(){
          expect(Faker.TestExtension.config.foo).not.toBeDefined();
        });

        it("should have the configs from its configure method", function() {
          expect(Faker.TestExtension.config.foo3).toBeDefined();
        });
      });

      describe("extending an extension", function() {
        beforeEach(function() {
          Faker.TestExtension  = Faker.extend({ foo2: 'bar2' });
          Faker.SubTestExtensionOfTestExtension = Faker.TestExtension.extend({ foo3: 'bar3' });
        });

        it("should not inherit the configs from Faker", function() {
          expect(Faker.TestExtension.foo2).toEqual('bar2');
          expect(Faker.SubTestExtensionOfTestExtension.foo2).toEqual(Faker.TestExtension.foo2);
          expect(Faker.TestExtension.foo3).not.toBeDefined();
          expect(Faker.SubTestExtensionOfTestExtension.foo3).toEqual('bar3');
        });
      });
    });
  });
});


describe("$.fn.faker", function() {
  it("binds to the jQuery object", function() {
    expect($).toBe(jQuery);
    expect($.fn.faker).toBeDefined();
  });
});