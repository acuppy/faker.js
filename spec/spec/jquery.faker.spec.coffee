describe "Faker", ->
  it "binds to the window", ->
    expect(Faker).toBeDefined()

  describe "Faker.config", ->
    describe "defaults", ->
      beforeEach  ->
        Faker.configure({})  
     
      it "should have locale", ->
        expect(Faker.config.locale).toEqual('en')
     
  describe "#configure", ->
    beforeEach  ->
      Faker.configure
        locale: 'es'
   
    afterEach ->
      Faker.configure({})
   
    it "should updated the Faker.config hash", ->
      expect(Faker.config.locale).toEqual('es')

  describe "#reset", ->
    beforeEach  ->
      Faker.configure({ locale: 'es' })
      Faker.reset()
   
    it "should updated the Faker.config hash", ->
      expect(Faker.config.locale).toEqual('en')
   
  describe "#init", ->
    beforeEach  ->
      spyOn(Faker, 'configure').andCallThrough()
      Faker.init()
   
    it "should call Faker.configure()", ->
      expect(Faker.configure).toHaveBeenCalled()
  
  describe "Faker.Lorem", ->
    it "binds to Faker", ->
      expect(Faker.Lorem).toBeDefined()  
   
    describe "#word", ->
      it "returns a string", ->
        expect($.type(Faker.Lorem.word())).toEqual('string')
     
      it "returns a single word", ->
        expect(Faker.Lorem.word()).toMatch(/^[a-zA-Z]+$/)
     
    describe "#words", ->
      it "returns an array of words based on quantity", ->
        expect( $.isArray(Faker.Lorem.words(3)) ).toBeTruthy()
     
      it "throws an error when the quantity is not an integer", ->
        expect(-> 
          Faker.Lorem.words('blah') 
        ).toThrow()
     
    describe "#characters", ->
      it "returns a string of characters", ->
        expect(Faker.Lorem.characters(16)).toMatch(/^[a-zA-Z0-9]{16}$/)
     
      describe "as array", ->
        it "returns an array of characters", ->
          expect( $.isArray(Faker.Lorem.characters(16, true)) ).toBeTruthy()
     
      it "throws an error when the quantity is not an integer", ->
        expect(-> 
          Faker.Lorem.characters('blah') 
        ).toThrow()
     
    describe "#sentence", ->
      it "returns a string", ->
        expect($.type(Faker.Lorem.sentence())).toEqual('string')
     
      it "returns a string representation", ->
        expect(Faker.Lorem.sentence()).toMatch(/^(?:(?:[a-zA-Z]+)\s?)+\.?$/)
     
      describe "options", ->
        describe "length", ->
          it "iterpretes the first argument as length", ->
            expect(Faker.Lorem.sentence(3)).toMatch(/^(?:(?:[a-zA-Z]+)\s?){3}\.?$/)
         
          it "finds length from hash options", ->
            expect(Faker.Lorem.sentence({
              length: 3 
            })).toMatch(/^(?:(?:[a-zA-Z]+)\s?){3}\.?$/)

        describe "startWithCapital", ->
          it "returns a string that starts capitalized", ->
            expect(Faker.Lorem.sentence()).toMatch(/^[^a-z](?:[a-zA-Z]+\s?)+\.?$/)
         
          it "returns a string that does NOT start capitalized", ->
            expect(Faker.Lorem.sentence({
              startWithCapital: false
            })).toMatch(/^[^A-Z](?:[a-zA-Z]+\s?)+\.?$/)

        describe "endWithPeriod", ->
          it "returns a string that ends with a period", ->
            expect(Faker.Lorem.sentence()).toMatch(/^(?:[a-zA-Z]+\s?)+\.?$/)

          it "returns a string that does NOT end with a period", ->
            expect(Faker.Lorem.sentence({
              endWithPeriod: false
            })).toMatch(/^(([a-zA-Z]+)\s?)+$/)

    describe "#sentences", ->
      it "returns a string of multiple sentences", ->
        expect(Faker.Lorem.sentences(3)).toMatch(/^(?:(?:\s?\w\s?)+\.){3}$/)
     
      describe "as array", ->
        it "returns an array of sentences", ->
          expect( $.isArray(Faker.Lorem.sentences(3, true)) ).toBeTruthy()
     
      describe "with options for #sentence passed as the second argument", ->
        spyOnSentence = null

        beforeEach  ->
          spyOnSentence  = spyOn(Faker.Lorem, 'sentence')
          Faker.Lorem.sentences 3, length: 5
     
        it "should pass the options to #sentence", ->
          expect(spyOnSentence).toHaveBeenCalledWith 
            length: 5
     
    describe "#paragraph", ->
      spyOnSentences = null

      beforeEach  ->
        spyOnSentences = spyOn(Faker.Lorem, 'sentences').andCallThrough()
     
      it "calls #sentences", ->
        Faker.Lorem.paragraph()
        expect(spyOnSentences).toHaveBeenCalledWith(3, {})
     
      it "returns a string", ->
        expect($.type(Faker.Lorem.paragraph())).toEqual('string')
     
      it "returns a string of multiple sentences", ->
        expect(Faker.Lorem.paragraph()).toMatch(/^(?:(?:\s?\w\s?)+\.){2,}$/)
     
      it "returns a string of sentences matching first argument", ->
        expect(Faker.Lorem.paragraph(2)).toMatch(/^(?:(?:\s?\w\s?)+\.){2}$/)
     
    describe "#paragraphs", ->
      spyOnParagraph = null

      beforeEach  ->
        spyOnParagraph = spyOn(Faker.Lorem, 'paragraph').andCallThrough()
     
      it "calls #paragraph", ->
        Faker.Lorem.paragraphs(3)
        expect(spyOnParagraph).toHaveBeenCalled()

      describe "as array", ->
        it "returns an array of paragraphs", ->
          expect( $.isArray(Faker.Lorem.paragraphs(3, true)) ).toBeTruthy()

  describe "Faker.Name", ->
    it "binds to Faker", ->
      expect(Faker.Name).toBeDefined()
   
    describe "#name", ->
      parts = null
      name = null

      beforeEach  ->
        spyOn(Faker.Util.Random, 'bool').andReturn(true)
        parts = Faker.Name.full_name().split ' '
        name  = Faker.Locales.en.name
     
      it "returns a fullname", ->
        expect( $.inArray(parts[0], name.prefix ) ).toBeTruthy()
        expect( $.inArray(parts[1], name.first_name ) ).toBeTruthy()
        expect( $.inArray(parts[2], name.last_name ) ).toBeTruthy()
        expect( $.inArray(parts[3], name.suffix ) ).toBeTruthy()
     
    describe "#prefix", ->
      it "returns a prefix", ->
        expect( $.inArray(Faker.Name.prefix(), Faker.Locales.en.name.prefix)).toBeTruthy()
     
    describe "#first_name", ->
      it "returns a first name", ->
        expect( $.inArray(Faker.Name.first_name(), Faker.Locales.en.name.first_name)).toBeTruthy()
     
    describe "#last_name", ->
      it "returns a last name", ->
        expect( $.inArray(Faker.Name.last_name(), Faker.Locales.en.name.last_name)).toBeTruthy()
     
    describe "#suffix", ->
      it "returns a suffix", ->
        expect( $.inArray(Faker.Name.suffix(), Faker.Locales.en.name.suffix)).toBeTruthy()
     
    describe "#title", ->
      parts = null

      beforeEach  ->
        parts = Faker.Name.title().split ' ' 
     
      it "returns a title", ->
        expect( $.inArray(parts[0], Faker.Locales.en.name.title.descriptor)).toBeTruthy()
        expect( $.inArray(parts[1], Faker.Locales.en.name.title.level)).toBeTruthy()
        expect( $.inArray(parts[2], Faker.Locales.en.name.title.job)).toBeTruthy()
     
  describe "Faker.Company", ->
    it "binds to Faker", ->
      expect(Faker.Company).toBeDefined()
   
    describe "#name", ->
      it "returns a string", ->
        expect($.type(Faker.Company.name())).toEqual('string')
     
      it "returns a name", ->
        expect(Faker.Company.name()).toMatch(/^(?:[a-zA-Z,'\-]+\s?)+$/)
     
    describe "#suffix", ->
      it "returns a string", ->
        expect($.type(Faker.Company.suffix())).toEqual('string')
     
      it "returns a suffix", ->
        expect(Faker.Company.suffix()).toMatch(/^(?:[a-zA-Z]+\s?)+$/)
     
    describe "#catch_phrase", ->
      it "returns a string", ->
        expect($.type(Faker.Company.catch_phrase())).toEqual('string')
     
      it "returns a sentence of values", ->
        expect(Faker.Company.catch_phrase()).toMatch(/^(?:[a-zA-Z0-9\-\/,']+\s?)+$/)
     
    describe "#bs", ->
      it "returns a string", ->
        expect($.type(Faker.Company.bs())).toEqual('string')
    
      it "returns a sentence of values", ->
        expect(Faker.Company.bs()).toMatch(/^(?:[a-zA-Z0-9\-\/,']+\s?)+$/)
     
  describe "Faker.Util", ->
    it "binds to Faker", ->
      expect(Faker.Util).toBeDefined()
   
    describe "Random", ->
      it "binds to Util", ->
        expect(Faker.Util.Random).toBeDefined()
     
      describe "#bool", ->
        it "returns a bool", ->
          expect( $.type(Faker.Util.Random.bool()) == 'boolean').toBeTruthy()
       
    describe "#isBlank", ->
      it "arrays", ->
        expect(Faker.Util.isBlank([])).toBeTruthy()
        expect(Faker.Util.isBlank(['foo', 'bar'])).toBeFalsy()
     
      it "strings", ->
        expect(Faker.Util.isBlank('')).toBeTruthy()
        expect(Faker.Util.isBlank('foo bar')).toBeFalsy()
     
      it "objects", ->
        expect(Faker.Util.isBlank({})).toBeTruthy()
        expect(Faker.Util.isBlank({ foo: 'bar' })).toBeFalsy()
     
    describe "#isPresent", ->
      it "arrays", ->
        expect(Faker.Util.isPresent([])).toBeFalsy()
        expect(Faker.Util.isPresent(['foo', 'bar'])).toBeTruthy()
     
      it "strings", ->
        expect(Faker.Util.isPresent('')).toBeFalsy()
        expect(Faker.Util.isPresent('foo bar')).toBeTruthy()
     
      it "objects", ->
        expect(Faker.Util.isPresent({})).toBeFalsy()
        expect(Faker.Util.isPresent( foo: 'bar' )).toBeTruthy()
     
    describe "#interpret", ->
      beforeEach  ->
        Faker.Locales.en =
          name:
            first_name: ["Aaliyah"]
            last_name:  ["Abbott"]

          company:
            suffix: ["Inc"]
     
      it "returns a string with the proper injections", ->
        str = '#{name.first_name} - #{name.last_name} - #{company.suffix}'
        exp = "Aaliyah - Abbott - Inc"
        expect(Faker.Util.interpret(str)).toEqual(exp)

    describe "#fix_umlauts", ->
      umlauts = 
        "ä": 'ae'
        "ö": 'oe'
        "ü": 'ue'
        "ß": 'ss'

      it "should fix ä", ->
        expect(Faker.Util.fix_umlauts('häppy')).toEqual('haeppy')

      it "should fix ö", ->
        expect(Faker.Util.fix_umlauts('höppy')).toEqual('hoeppy')

      it "should fix ü", ->
        expect(Faker.Util.fix_umlauts('hüppy')).toEqual('hueppy')

      it "should fix ß", ->
        expect(Faker.Util.fix_umlauts('hßppy')).toEqual('hssppy')
     
  describe "Faker.Locale", ->
    it "binds to Faker", ->
      expect(Faker.Locale).toBeDefined()
   
    describe "#sample", ->
      collection = ["foo", "bar"]

      beforeEach  ->
        spyOn(Faker.Locale, 'collection').andReturn(collection)
     
      it "returns one of two", ->
        expect( $.inArray(Faker.Locale.sample('foo.bar'), collection)).toBeTruthy()
     
    describe "#collection", ->
      it "returns a collection from a locale based on the key", ->
        pending()
     
    describe "#register", ->
      spyOnLocales = null

      beforeEach  ->
        spyOnLocales = spyOn(Faker.Locales, 'en')
        Faker.Locale.register 'es', 
          name: ["jesus", "juan"]
     
      it "creates a new object instance with the collection", ->
        expect(Faker.Locales.es).toBeDefined()
     
      it "binds the collection to the Locale", ->
        expect(Faker.Locales.es.name).toEqual ["jesus", "juan"]
     
    xdescribe "#extend", ->
      beforeEach  ->
        Faker.Locales.en = 
          foo: "bar"
          arr: ['stuff', 'things']
        collection = 
          blah: 'blah'
          arr: ['blah']

        Faker.Locale.register 'en', collection
     
      xit "extends the existing collection", ->
        expect( Faker.Util.isPresent(Faker.Locales.en.arr['stuff']) ).toBeTruthy()
        expect( Faker.Util.isPresent(Faker.Locales.en.arr['blah']) ).toBeTruthy()
        expect( Faker.Locales.en.foo == "bar" ).toBeTruthy()
        expect( Faker.Locales.en.blah == "blah" ).toBeTruthy()
     
  describe "Extensions", ->
    describe "#extend", ->
      beforeEach  ->
        spyOn($, 'extend').andCallThrough()

        Faker.TestExtension = Faker.extend
          custom_method: $.noop
       
      it "should have the newly added extension methods", ->
        expect(Faker.TestExtension.custom_method).toBeDefined()
     
      it "should extend Faker.Extension.Base", ->
        expect($.extend).toHaveBeenCalled()
     
      describe "configs", ->
        beforeEach  ->
          Faker.configure
            foo: 'bar'
         
          Faker.TestExtension.configure
            foo3: 'bar3'
         
        it "should not inherit the configs from Faker", ->
          expect(Faker.config.foo).toBeDefined()
       
        it "should not have extended the parent extension", ->
          expect(Faker.config.foo2).not.toBeDefined()
       
        it "should not inherit the configs from Faker", ->
          expect(Faker.TestExtension.config.foo).not.toBeDefined()
       
        it "should have the configs from its configure method", ->
          expect(Faker.TestExtension.config.foo3).toBeDefined()
       
      describe "extending an extension", ->
        beforeEach  ->
          Faker.TestExtension  = Faker.extend foo2: 'bar2'
          Faker.SubTestExtensionOfTestExtension = Faker.TestExtension.extend foo3: 'bar3'
       
        it "should inherit from its parent", ->
          expect(Faker.SubTestExtensionOfTestExtension.foo2).toEqual(Faker.TestExtension.foo2)
       
        it "should not pass its properties up the chain", ->
          expect(Faker.TestExtension.foo3).not.toBeDefined()
       
        it "should have its own properties", ->
          expect(Faker.SubTestExtensionOfTestExtension.foo3).toEqual('bar3')

describe "$.fn.faker", ->
  it "binds to the jQuery object", ->
    expect($).toBe(jQuery)
    expect($.fn.faker).toBeDefined()