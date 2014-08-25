describe "Faker", ->
  it "binds to the window", ->
    expect(Faker).toBeDefined()


  beforeEach ->
    spyOn(console, 'log').andCallThrough()

  afterEach ->
    expect(console.log).not.toHaveBeenCalled()

  describe "Faker.config", ->
    describe "defaults", ->
      beforeEach  ->
        Faker.configure({})

      it "should have locale", ->
        expect(Faker.config.locale).toEqual('en')

  describe "#configure", ->
    beforeEach  ->
      Faker.configure locale: 'es'

    afterEach ->
      Faker.configure({})

    it "should updated the Faker.config hash", ->
      expect(Faker.config.locale).toEqual('es')

  describe "#reset", ->
    beforeEach  ->
      Faker.configure locale: 'es'
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
            expect(Faker.Lorem.sentence()).toMatch(/^[^a-z][A-Z]?(?:[a-zA-Z]+\s?)+\.?$/)

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
        parts = Faker.Name.fullName().split ' '
        name  = Faker.Locales.en.name

      it "returns a fullname", ->
        expect( $.inArray(parts[0], name.prefix ) ).toBeTruthy()
        expect( $.inArray(parts[1], name.firstName ) ).toBeTruthy()
        expect( $.inArray(parts[2], name.lastName ) ).toBeTruthy()
        expect( $.inArray(parts[3], name.suffix ) ).toBeTruthy()

    describe "#prefix", ->
      it "returns a prefix", ->
        expect( $.inArray(Faker.Name.prefix(), Faker.Locales.en.name.prefix)).toBeTruthy()

    describe "#firstName", ->
      it "returns a first name", ->
        expect( $.inArray(Faker.Name.firstName(), Faker.Locales.en.name.firstName)).toBeTruthy()

    describe "#lastName", ->
      it "returns a last name", ->
        expect( $.inArray(Faker.Name.lastName(), Faker.Locales.en.name.lastName)).toBeTruthy()

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

    describe "#catchPhrase", ->
      it "returns a string", ->
        expect($.type(Faker.Company.catchPhrase())).toEqual('string')

      it "returns a sentence of values", ->
        expect(Faker.Company.catchPhrase()).toMatch(/^(?:[a-zA-Z0-9\-\/,']+\s?)+$/)

    describe "#bs", ->
      it "returns a string", ->
        expect($.type(Faker.Company.bs())).toEqual('string')

      it "returns a sentence of values", ->
        expect(Faker.Company.bs()).toMatch(/^(?:[a-zA-Z0-9\-\/,']+\s?)+$/)

  describe "Faker.Internet", ->
    it "binds to Faker", ->
      expect(Faker.Internet).toBeDefined();

    describe "#email", ->
      beforeEach ->
        spyOn(Faker.Internet, 'userName').andCallThrough()
        spyOn(Faker.Internet, 'domainName').andCallThrough()

      it "returns an email address from a username and domain", ->
        expect(Faker.Internet.email()).toMatch(/\w+\@[a-zA-Z]+\.[a-z]{2,}/)

      it "expects to have used Faker.Internet.userName", ->
        Faker.Internet.email()
        expect(Faker.Internet.userName).toHaveBeenCalled();

      it "expects to have used Faker.Internet.domainName", ->
        Faker.Internet.email()
        expect(Faker.Internet.domainName).toHaveBeenCalled();

    describe "#freeEmail", ->
      beforeEach ->
        spyOn(Faker.Internet, 'userName').andCallThrough()

      it "returns an email address for a popular free email provider", ->
        expect(Faker.Internet.freeEmail()).toMatch(/\w+\@(?:gmail|yahoo|hotmail)\.com/)

      it "expects to have used Faker.Internet.userName", ->
        Faker.Internet.freeEmail()
        expect(Faker.Internet.userName).toHaveBeenCalled();

    describe "#safeEmail", ->
      beforeEach ->
        spyOn(Faker.Internet, 'userName').andCallThrough()

      it "returns an email address using example as the domain", ->
        expect(Faker.Internet.safeEmail()).toMatch(/\w+\@example\.(?:com|net|org)/)

      it "expects to have used Faker.Internet.userName", ->
        Faker.Internet.safeEmail()
        expect(Faker.Internet.userName).toHaveBeenCalled();

    describe "#userName", ->
      beforeEach ->
        spyOn(Faker.Name, 'firstName').andCallThrough()
        spyOn(Faker.Util, 'fixUmlauts').andCallThrough()

      it "expects to have used Faker.Name.firstName", ->
        Faker.Internet.userName()
        expect(Faker.Name.firstName).toHaveBeenCalled()

      it "expects to have fixed umlauts", ->
        Faker.Internet.userName()
        expect(Faker.Util.fixUmlauts).toHaveBeenCalled()

      it "returns a string without whitespace characters", ->
        expect(Faker.Internet.userName()).not.toMatch(/\W/gi)

    describe "#domainName", ->
      beforeEach ->
        spyOn(Faker.Internet, 'domainWord').andCallThrough()
        spyOn(Faker.Util, 'fixUmlauts').andCallThrough()

      it "returns a string with a TLD", ->
        expect(Faker.Internet.domainName()).toMatch(/\w+\.[a-z]{2,}/)

      it "expects to have fixed umlauts", ->
        Faker.Internet.domainName()
        expect(Faker.Util.fixUmlauts).toHaveBeenCalled()

      it "expects to have domainWord called", ->
        Faker.Internet.domainName()
        expect(Faker.Internet.domainWord).toHaveBeenCalled()

    describe "#domainWord", ->
      beforeEach ->
        spyOn(Faker.Company, 'name').andCallThrough()

      it "returns a string", ->
        expect(Faker.Internet.domainWord()).not.toMatch(/\W/gi)

      it "expects to have called Faker.Company.name", ->
        Faker.Company.name()
        expect(Faker.Company.name).toHaveBeenCalled()

    describe "#domainSuffix", ->
      it "returns a TLD", ->
        expect( $.inArray(Faker.Internet.domainSuffix(), ["com", "biz", "info", "name", "net", "org"])).toBeTruthy()

    describe "#ipV4Address", ->
      it "returns a valid formatted ipv4 address", ->
        expect( Faker.Internet.ipV4Address() ).toMatch(/^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/)

    describe "#ipV6Address", ->
      it "returns a valid formatted ipv6 address", ->
        pending()
        expect( Faker.Internet.ipV6Address() ).toMatch(/^$/)

    describe "#slug", ->
      it "returns a string separated", ->
        expect(Faker.Internet.slug()).toMatch(/^[a-zA-Z0-9\-\_\.]+$/)

      describe "with options", ->
        it "should use the words provided", ->
          expect(Faker.Internet.slug('happy birthday')).toMatch(/^happy(?:[\-\_\.])birthday$/)

        it "should use the glue provided", ->
          expect(Faker.Internet.slug('happy birthday', ':')).toMatch(/^happy:birthday$/)

  describe "Faker.PhoneNumber", ->
    describe "#phoneNumber", ->
      it "returns a value with valid separators and integers", ->
        expect(Faker.PhoneNumber.phoneNumber()).toMatch(/^[^0][^2-9]1?[0-9\-\(\)\.]+((ext\.|x)?\s?[0-9]+)?$/)

    describe "#tollFree", ->
      beforeEach ->
        spyOn(Faker.PhoneNumber, 'phoneNumber')

      it "should call phoneNumber", ->
        Faker.PhoneNumber.tollFree()
        expect(Faker.PhoneNumber.phoneNumber).toHaveBeenCalled()

      it "returns a number with the area code 800/866/855", ->
       expect(Faker.PhoneNumber.tollFree()).toMatch(/(?:800|888|866|855|877)/)

  describe "Faker.Util", ->
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
            firstName: ["Aaliyah"]
            lastName:  ["Abbott"]
          company:
            suffix: ["Inc"]

      it "returns a string with the proper injections", ->
        str = '#{name.firstName} - #{name.lastName} - #{company.suffix}'
        exp = "Aaliyah - Abbott - Inc"
        expect(Faker.Util.interpret(str)).toEqual(exp)

    describe "#fixUmlauts", ->
      umlauts =
        "ä": 'ae'
        "ö": 'oe'
        "ü": 'ue'
        "ß": 'ss'

      it "should fix ä", ->
        expect(Faker.Util.fixUmlauts('häppy')).toEqual('haeppy')

      it "should fix ö", ->
        expect(Faker.Util.fixUmlauts('höppy')).toEqual('hoeppy')

      it "should fix ü", ->
        expect(Faker.Util.fixUmlauts('hüppy')).toEqual('hueppy')

      it "should fix ß", ->
        expect(Faker.Util.fixUmlauts('hßppy')).toEqual('hssppy')

    describe "#fixNonWordChars", ->
      it "should convert apostrophies", ->
        expect(Faker.Util.fixNonWordChars("o'reilly")).toEqual('oreilly')

      it "should convert commas", ->
        expect(Faker.Util.fixNonWordChars("o,reilly")).toEqual('oreilly')

      it "should convert spaces", ->
        expect(Faker.Util.fixNonWordChars("o reilly")).toEqual('oreilly')

      it "should convert random non-word characters", ->
        expect(Faker.Util.fixNonWordChars("o*%^$^%$reilly")).toEqual('oreilly')

  describe "Faker.Util.Numbers", ->
    describe "#range", ->
      it "returns an array of numbers", ->
        expect(Faker.Util.Numbers.range(1,10)).toEqual([1,2,3,4,5,6,7,8,9,10])

    describe "#sample", ->
      beforeEach ->
        spyOn(Faker.Util.Numbers, 'range').andReturn([0,1,2,3,4,5,6,7,8,9])

      it "should call range", ->
        Faker.Util.Numbers.sample(0,9)
        expect(Faker.Util.Numbers.range).toHaveBeenCalledWith(0,9)

      it "should return a single integer", ->
        expect(Faker.Util.Numbers.sample(0,9)).toMatch(/^\d$/)
        expect(Faker.Util.Numbers.sample(13,99)).toMatch(/^\d+$/)

  describe "Faker.Util.Alpha", ->
    describe "#range", ->
      it "returns an array of alpha characters", ->
        expect(Faker.Util.Alpha.range('a','e')).toEqual(['a','b','c','d','e'])

      it "returns an array of alpha characters that span capitalization", ->
        expect(Faker.Util.Alpha.range('y','B')).toEqual(['y','z','A','B'])

    describe "#sample", ->
      beforeEach ->
        spyOn(Faker.Util.Numbers, 'range').andReturn(['a','b','c','d','e'])

      it "should call range", ->
        Faker.Util.Numbers.sample('a', 'e')
        expect(Faker.Util.Numbers.range).toHaveBeenCalledWith('a','e')

      it "should return a single letter", ->
        expect(Faker.Util.Numbers.sample('a','e')).toMatch(/^[a-e]{1}$/)

  describe "Faker.Locale", ->
    it "binds to Faker", ->
      expect(Faker.Locale).toBeDefined()

    describe "#sample", ->
      collection = ["foo", "bar"]

      beforeEach  ->
        spyOn(Faker.Locale, 'collection').andReturn(collection)

      it "returns one of two", ->
        expect( $.inArray(Faker.Locale.sample('foo.bar'), collection)).toBeTruthy()

      describe "when selecting one sample", ->
        it "does NOT return an array", ->
          expect( $.type(Faker.Locale.sample('foo.bar')) == 'string' ).toBeTruthy()

      describe "when selecting more than one sample", ->
        it "returns an array", ->
          expect( $.isArray(Faker.Locale.sample('foo.bar', 2)) ).toBeTruthy()

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
          customMethod: $.noop

      it "should have the newly added extension methods", ->
        expect(Faker.TestExtension.customMethod).toBeDefined()

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
