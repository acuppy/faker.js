(function() {

  describe("Faker", function() {
    it("binds to the window", function() {
      return expect(Faker).toBeDefined();
    });
    describe("Faker.config", function() {
      return describe("defaults", function() {
        beforeEach(function() {
          return Faker.configure({});
        });
        return it("should have locale", function() {
          return expect(Faker.config.locale).toEqual('en');
        });
      });
    });
    describe("#configure", function() {
      beforeEach(function() {
        return Faker.configure({
          locale: 'es'
        });
      });
      afterEach(function() {
        return Faker.configure({});
      });
      return it("should updated the Faker.config hash", function() {
        return expect(Faker.config.locale).toEqual('es');
      });
    });
    describe("#reset", function() {
      beforeEach(function() {
        Faker.configure({
          locale: 'es'
        });
        return Faker.reset();
      });
      return it("should updated the Faker.config hash", function() {
        return expect(Faker.config.locale).toEqual('en');
      });
    });
    describe("#init", function() {
      beforeEach(function() {
        spyOn(Faker, 'configure').andCallThrough();
        return Faker.init();
      });
      return it("should call Faker.configure()", function() {
        return expect(Faker.configure).toHaveBeenCalled();
      });
    });
    describe("Faker.Lorem", function() {
      it("binds to Faker", function() {
        return expect(Faker.Lorem).toBeDefined();
      });
      describe("#word", function() {
        it("returns a string", function() {
          return expect($.type(Faker.Lorem.word())).toEqual('string');
        });
        return it("returns a single word", function() {
          return expect(Faker.Lorem.word()).toMatch(/^[a-zA-Z]+$/);
        });
      });
      describe("#words", function() {
        it("returns an array of words based on quantity", function() {
          return expect($.isArray(Faker.Lorem.words(3))).toBeTruthy();
        });
        return it("throws an error when the quantity is not an integer", function() {
          return expect(function() {
            return Faker.Lorem.words('blah');
          }).toThrow();
        });
      });
      describe("#characters", function() {
        it("returns a string of characters", function() {
          return expect(Faker.Lorem.characters(16)).toMatch(/^[a-zA-Z0-9]{16}$/);
        });
        describe("as array", function() {
          return it("returns an array of characters", function() {
            return expect($.isArray(Faker.Lorem.characters(16, true))).toBeTruthy();
          });
        });
        return it("throws an error when the quantity is not an integer", function() {
          return expect(function() {
            return Faker.Lorem.characters('blah');
          }).toThrow();
        });
      });
      describe("#sentence", function() {
        it("returns a string", function() {
          return expect($.type(Faker.Lorem.sentence())).toEqual('string');
        });
        it("returns a string representation", function() {
          return expect(Faker.Lorem.sentence()).toMatch(/^(?:(?:[a-zA-Z]+)\s?)+\.?$/);
        });
        return describe("options", function() {
          describe("length", function() {
            it("iterpretes the first argument as length", function() {
              return expect(Faker.Lorem.sentence(3)).toMatch(/^(?:(?:[a-zA-Z]+)\s?){3}\.?$/);
            });
            return it("finds length from hash options", function() {
              return expect(Faker.Lorem.sentence({
                length: 3
              })).toMatch(/^(?:(?:[a-zA-Z]+)\s?){3}\.?$/);
            });
          });
          describe("startWithCapital", function() {
            it("returns a string that starts capitalized", function() {
              return expect(Faker.Lorem.sentence()).toMatch(/^[^a-z](?:[a-zA-Z]+\s?)+\.?$/);
            });
            return it("returns a string that does NOT start capitalized", function() {
              return expect(Faker.Lorem.sentence({
                startWithCapital: false
              })).toMatch(/^[^A-Z](?:[a-zA-Z]+\s?)+\.?$/);
            });
          });
          return describe("endWithPeriod", function() {
            it("returns a string that ends with a period", function() {
              return expect(Faker.Lorem.sentence()).toMatch(/^(?:[a-zA-Z]+\s?)+\.?$/);
            });
            return it("returns a string that does NOT end with a period", function() {
              return expect(Faker.Lorem.sentence({
                endWithPeriod: false
              })).toMatch(/^(([a-zA-Z]+)\s?)+$/);
            });
          });
        });
      });
      describe("#sentences", function() {
        it("returns a string of multiple sentences", function() {
          return expect(Faker.Lorem.sentences(3)).toMatch(/^(?:(?:\s?\w\s?)+\.){3}$/);
        });
        describe("as array", function() {
          return it("returns an array of sentences", function() {
            return expect($.isArray(Faker.Lorem.sentences(3, true))).toBeTruthy();
          });
        });
        return describe("with options for #sentence passed as the second argument", function() {
          var spyOnSentence;
          spyOnSentence = null;
          beforeEach(function() {
            spyOnSentence = spyOn(Faker.Lorem, 'sentence');
            return Faker.Lorem.sentences(3, {
              length: 5
            });
          });
          return it("should pass the options to #sentence", function() {
            return expect(spyOnSentence).toHaveBeenCalledWith({
              length: 5
            });
          });
        });
      });
      describe("#paragraph", function() {
        var spyOnSentences;
        spyOnSentences = null;
        beforeEach(function() {
          return spyOnSentences = spyOn(Faker.Lorem, 'sentences').andCallThrough();
        });
        it("calls #sentences", function() {
          Faker.Lorem.paragraph();
          return expect(spyOnSentences).toHaveBeenCalledWith(3, {});
        });
        it("returns a string", function() {
          return expect($.type(Faker.Lorem.paragraph())).toEqual('string');
        });
        it("returns a string of multiple sentences", function() {
          return expect(Faker.Lorem.paragraph()).toMatch(/^(?:(?:\s?\w\s?)+\.){2,}$/);
        });
        return it("returns a string of sentences matching first argument", function() {
          return expect(Faker.Lorem.paragraph(2)).toMatch(/^(?:(?:\s?\w\s?)+\.){2}$/);
        });
      });
      return describe("#paragraphs", function() {
        var spyOnParagraph;
        spyOnParagraph = null;
        beforeEach(function() {
          return spyOnParagraph = spyOn(Faker.Lorem, 'paragraph').andCallThrough();
        });
        it("calls #paragraph", function() {
          Faker.Lorem.paragraphs(3);
          return expect(spyOnParagraph).toHaveBeenCalled();
        });
        return describe("as array", function() {
          return it("returns an array of paragraphs", function() {
            return expect($.isArray(Faker.Lorem.paragraphs(3, true))).toBeTruthy();
          });
        });
      });
    });
    describe("Faker.Name", function() {
      it("binds to Faker", function() {
        return expect(Faker.Name).toBeDefined();
      });
      describe("#name", function() {
        var name, parts;
        parts = null;
        name = null;
        beforeEach(function() {
          spyOn(Faker.Util.Random, 'bool').andReturn(true);
          parts = Faker.Name.full_name().split(' ');
          return name = Faker.Locales.en.name;
        });
        return it("returns a fullname", function() {
          expect($.inArray(parts[0], name.prefix)).toBeTruthy();
          expect($.inArray(parts[1], name.first_name)).toBeTruthy();
          expect($.inArray(parts[2], name.last_name)).toBeTruthy();
          return expect($.inArray(parts[3], name.suffix)).toBeTruthy();
        });
      });
      describe("#prefix", function() {
        return it("returns a prefix", function() {
          return expect($.inArray(Faker.Name.prefix(), Faker.Locales.en.name.prefix)).toBeTruthy();
        });
      });
      describe("#first_name", function() {
        return it("returns a first name", function() {
          return expect($.inArray(Faker.Name.first_name(), Faker.Locales.en.name.first_name)).toBeTruthy();
        });
      });
      describe("#last_name", function() {
        return it("returns a last name", function() {
          return expect($.inArray(Faker.Name.last_name(), Faker.Locales.en.name.last_name)).toBeTruthy();
        });
      });
      describe("#suffix", function() {
        return it("returns a suffix", function() {
          return expect($.inArray(Faker.Name.suffix(), Faker.Locales.en.name.suffix)).toBeTruthy();
        });
      });
      return describe("#title", function() {
        var parts;
        parts = null;
        beforeEach(function() {
          return parts = Faker.Name.title().split(' ');
        });
        return it("returns a title", function() {
          expect($.inArray(parts[0], Faker.Locales.en.name.title.descriptor)).toBeTruthy();
          expect($.inArray(parts[1], Faker.Locales.en.name.title.level)).toBeTruthy();
          return expect($.inArray(parts[2], Faker.Locales.en.name.title.job)).toBeTruthy();
        });
      });
    });
    describe("Faker.Company", function() {
      it("binds to Faker", function() {
        return expect(Faker.Company).toBeDefined();
      });
      describe("#name", function() {
        it("returns a string", function() {
          return expect($.type(Faker.Company.name())).toEqual('string');
        });
        return it("returns a name", function() {
          return expect(Faker.Company.name()).toMatch(/^(?:[a-zA-Z,'\-]+\s?)+$/);
        });
      });
      describe("#suffix", function() {
        it("returns a string", function() {
          return expect($.type(Faker.Company.suffix())).toEqual('string');
        });
        return it("returns a suffix", function() {
          return expect(Faker.Company.suffix()).toMatch(/^(?:[a-zA-Z]+\s?)+$/);
        });
      });
      describe("#catch_phrase", function() {
        it("returns a string", function() {
          return expect($.type(Faker.Company.catch_phrase())).toEqual('string');
        });
        return it("returns a sentence of values", function() {
          return expect(Faker.Company.catch_phrase()).toMatch(/^(?:[a-zA-Z0-9\-\/,']+\s?)+$/);
        });
      });
      return describe("#bs", function() {
        it("returns a string", function() {
          return expect($.type(Faker.Company.bs())).toEqual('string');
        });
        return it("returns a sentence of values", function() {
          return expect(Faker.Company.bs()).toMatch(/^(?:[a-zA-Z0-9\-\/,']+\s?)+$/);
        });
      });
    });
    describe("Faker.Util", function() {
      it("binds to Faker", function() {
        return expect(Faker.Util).toBeDefined();
      });
      describe("Random", function() {
        it("binds to Util", function() {
          return expect(Faker.Util.Random).toBeDefined();
        });
        return describe("#bool", function() {
          return it("returns a bool", function() {
            return expect($.type(Faker.Util.Random.bool()) === 'boolean').toBeTruthy();
          });
        });
      });
      describe("#isBlank", function() {
        it("arrays", function() {
          expect(Faker.Util.isBlank([])).toBeTruthy();
          return expect(Faker.Util.isBlank(['foo', 'bar'])).toBeFalsy();
        });
        it("strings", function() {
          expect(Faker.Util.isBlank('')).toBeTruthy();
          return expect(Faker.Util.isBlank('foo bar')).toBeFalsy();
        });
        return it("objects", function() {
          expect(Faker.Util.isBlank({})).toBeTruthy();
          return expect(Faker.Util.isBlank({
            foo: 'bar'
          })).toBeFalsy();
        });
      });
      describe("#isPresent", function() {
        it("arrays", function() {
          expect(Faker.Util.isPresent([])).toBeFalsy();
          return expect(Faker.Util.isPresent(['foo', 'bar'])).toBeTruthy();
        });
        it("strings", function() {
          expect(Faker.Util.isPresent('')).toBeFalsy();
          return expect(Faker.Util.isPresent('foo bar')).toBeTruthy();
        });
        return it("objects", function() {
          expect(Faker.Util.isPresent({})).toBeFalsy();
          return expect(Faker.Util.isPresent({
            foo: 'bar'
          })).toBeTruthy();
        });
      });
      describe("#interpret", function() {
        beforeEach(function() {
          return Faker.Locales.en = {
            name: {
              first_name: ["Aaliyah"],
              last_name: ["Abbott"]
            },
            company: {
              suffix: ["Inc"]
            }
          };
        });
        return it("returns a string with the proper injections", function() {
          var exp, str;
          str = '#{name.first_name} - #{name.last_name} - #{company.suffix}';
          exp = "Aaliyah - Abbott - Inc";
          return expect(Faker.Util.interpret(str)).toEqual(exp);
        });
      });
      return describe("#fix_umlauts", function() {
        var umlauts;
        umlauts = {
          "ä": 'ae',
          "ö": 'oe',
          "ü": 'ue',
          "ß": 'ss'
        };
        it("should fix ä", function() {
          return expect(Faker.Util.fix_umlauts('häppy')).toEqual('haeppy');
        });
        it("should fix ö", function() {
          return expect(Faker.Util.fix_umlauts('höppy')).toEqual('hoeppy');
        });
        it("should fix ü", function() {
          return expect(Faker.Util.fix_umlauts('hüppy')).toEqual('hueppy');
        });
        return it("should fix ß", function() {
          return expect(Faker.Util.fix_umlauts('hßppy')).toEqual('hssppy');
        });
      });
    });
    describe("Faker.Locale", function() {
      it("binds to Faker", function() {
        return expect(Faker.Locale).toBeDefined();
      });
      describe("#sample", function() {
        var collection;
        collection = ["foo", "bar"];
        beforeEach(function() {
          return spyOn(Faker.Locale, 'collection').andReturn(collection);
        });
        return it("returns one of two", function() {
          return expect($.inArray(Faker.Locale.sample('foo.bar'), collection)).toBeTruthy();
        });
      });
      describe("#collection", function() {
        return it("returns a collection from a locale based on the key", function() {
          return pending();
        });
      });
      describe("#register", function() {
        var spyOnLocales;
        spyOnLocales = null;
        beforeEach(function() {
          spyOnLocales = spyOn(Faker.Locales, 'en');
          return Faker.Locale.register('es', {
            name: ["jesus", "juan"]
          });
        });
        it("creates a new object instance with the collection", function() {
          return expect(Faker.Locales.es).toBeDefined();
        });
        return it("binds the collection to the Locale", function() {
          return expect(Faker.Locales.es.name).toEqual(["jesus", "juan"]);
        });
      });
      return xdescribe("#extend", function() {
        beforeEach(function() {
          var collection;
          Faker.Locales.en = {
            foo: "bar",
            arr: ['stuff', 'things']
          };
          collection = {
            blah: 'blah',
            arr: ['blah']
          };
          return Faker.Locale.register('en', collection);
        });
        return xit("extends the existing collection", function() {
          expect(Faker.Util.isPresent(Faker.Locales.en.arr['stuff'])).toBeTruthy();
          expect(Faker.Util.isPresent(Faker.Locales.en.arr['blah'])).toBeTruthy();
          expect(Faker.Locales.en.foo === "bar").toBeTruthy();
          return expect(Faker.Locales.en.blah === "blah").toBeTruthy();
        });
      });
    });
    return describe("Extensions", function() {
      return describe("#extend", function() {
        beforeEach(function() {
          spyOn($, 'extend').andCallThrough();
          return Faker.TestExtension = Faker.extend({
            custom_method: $.noop
          });
        });
        it("should have the newly added extension methods", function() {
          return expect(Faker.TestExtension.custom_method).toBeDefined();
        });
        it("should extend Faker.Extension.Base", function() {
          return expect($.extend).toHaveBeenCalled();
        });
        describe("configs", function() {
          beforeEach(function() {
            Faker.configure({
              foo: 'bar'
            });
            return Faker.TestExtension.configure({
              foo3: 'bar3'
            });
          });
          it("should not inherit the configs from Faker", function() {
            return expect(Faker.config.foo).toBeDefined();
          });
          it("should not have extended the parent extension", function() {
            return expect(Faker.config.foo2).not.toBeDefined();
          });
          it("should not inherit the configs from Faker", function() {
            return expect(Faker.TestExtension.config.foo).not.toBeDefined();
          });
          return it("should have the configs from its configure method", function() {
            return expect(Faker.TestExtension.config.foo3).toBeDefined();
          });
        });
        return describe("extending an extension", function() {
          beforeEach(function() {
            Faker.TestExtension = Faker.extend({
              foo2: 'bar2'
            });
            return Faker.SubTestExtensionOfTestExtension = Faker.TestExtension.extend({
              foo3: 'bar3'
            });
          });
          it("should inherit from its parent", function() {
            return expect(Faker.SubTestExtensionOfTestExtension.foo2).toEqual(Faker.TestExtension.foo2);
          });
          it("should not pass its properties up the chain", function() {
            return expect(Faker.TestExtension.foo3).not.toBeDefined();
          });
          return it("should have its own properties", function() {
            return expect(Faker.SubTestExtensionOfTestExtension.foo3).toEqual('bar3');
          });
        });
      });
    });
  });

  describe("$.fn.faker", function() {
    return it("binds to the jQuery object", function() {
      expect($).toBe(jQuery);
      return expect($.fn.faker).toBeDefined();
    });
  });

}).call(this);
