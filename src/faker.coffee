$ = jQuery

Faker = {}

Faker.Base =
  config: {}
  reset: ->
    @configure {}
    return

  configure: (configs) ->
    $.error "Hash expected -- received #{$.type(configs)}" unless $.isPlainObject(configs)

    baseConfig =
      locale: 'en'

    @config = $.extend(true, {}, baseConfig, configs)
    return

  extend: (extension) ->
    $.extend(true, {}, this, extension || {})

# rebase the Faker object on the Base object
Faker = $.extend(true, {}, Faker.Base)
# alias the init method to reset for now
Faker.init = Faker.reset

Faker.Lorem = Faker.extend
  word: ->
    Faker.Locale.sample("lorem.words")

  words: (qty) ->
    $.error "Quantity must be a valid integer" unless $.isNumeric qty
    Faker.Locale.sample "lorem.words", qty

  characters: (qty, as_array) ->
    $.error("Quantity must be a valid integer") unless $.isNumeric(qty)
    arr = Faker.Locale.sample("lorem.characters", qty)
    if as_array == true then arr else arr.join('')

  sentence: (options) ->
    options = { length: options } if $.isNumeric(options)

    opt = $.extend({
      length: 10
      startWithCapital: true
      endWithPeriod: true
    }, options)

    arr    = @words opt.length
    arr[0] = "#{arr[0].charAt(0).toUpperCase()}#{arr[0].slice(1)}" if opt.startWithCapital == true

    sentence = arr.join ' '
    sentence += '.' if opt.endWithPeriod == true
    sentence

  sentences: (qty) ->
    $.error "Quantity must be a valid integer" unless $.isNumeric qty

    args      = Array.prototype.slice.call arguments, 1
    options   = {}
    as_array  = false
    sentences = new Array()

    if args.length > 0 and $.type(args[args.length - 1]) == 'boolean'  then as_array = args[args.length - 1]
    if $.isArray(args) and args.length > 0 and $.isPlainObject args[0] then $.extend options, args[0]

    for i in [0...qty]
      sentences.push @sentence options

    if as_array == true then sentences else sentences.join ' ' 

  paragraph: (sentences, options) ->
    sentences ?= 3
    options   ?= {}

    $.error "First argument must be a valid integer" unless $.isNumeric sentences

    @sentences sentences, options

  paragraphs: (qty) ->
    $.error "Quantity must be a valid integer" unless $.isNumeric qty

    args      = Array.prototype.slice.call arguments, 1
    options   = {}
    as_array  = false
    paragraphs = new Array()

    if args.length > 0 and $.type(args[args.length - 1]) == 'boolean' then as_array = args[args.length - 1]  
    if $.isArray args and args.length > 0 and $.isPlainObject args[0] then $.extend options, args[0]

    for i in [0...qty]
      paragraphs.push @paragraph 3, options

    if as_array == true then paragraphs else paragraphs.join(' ')

Faker.Name = Faker.extend
  full_name: ->
    name = new Array();
    name.push this.prefix() if Faker.Util.Random.bool()
    name.push this.first_name()
    name.push this.last_name()
    name.push this.suffix() if Faker.Util.Random.bool()
    name.join(' ')

  prefix: ->
    Faker.Locale.sample('name.prefix')

  first_name: ->
    Faker.Locale.sample('name.first_name')

  last_name: ->
    Faker.Locale.sample('name.last_name')

  suffix: ->
    Faker.Locale.sample('name.suffix')

  title: ->
    title = new Array()
    title.push Faker.Locale.sample('name.title.descriptor')
    title.push Faker.Locale.sample('name.title.level')
    title.push Faker.Locale.sample('name.title.job')
    title.join(' ')

Faker.Company = Faker.extend
  name: ->
    Faker.Util.interpret Faker.Locale.sample("company.name")

  suffix: ->
    Faker.Locale.sample("company.suffix")

  catch_phrase: ->
    $.map(Faker.Locale.collection("company.buzzwords"), (elm, i) ->
      Faker.Util.Random.sample(elm)
    ).join(' ')

  bs: ->
    $.map(Faker.Locale.collection("company.bs"), (elm, i) ->
      Faker.Util.Random.sample(elm)
    ).join(' ')

Faker.Internet = Faker.extend
  email: ->
    [ @user_name(), @domain_name() ].join('@')

  free_email: ->
    [ @user_name(), Faker.Locale.sample('internet.free_email') ].join('@')

  safe_email: ->
    [ @user_name(), "example.#{Faker.Util.Random.sample(['com', 'net', 'org'])}" ].join('@')

  user_name: ->
    samples = [
      (-> Faker.Util.fix_non_word_chars(Faker.Name.first_name())),
      (-> $.map([ Faker.Name.first_name(), Faker.Name.last_name()], (elm, index) -> 
          Faker.Util.fix_non_word_chars(elm)).join('_').toLowerCase())
    ]

    Faker.Util.fix_umlauts( Faker.Util.Random.sample(samples).call() )

  domain_name: ->
    [ Faker.Util.fix_umlauts( @domain_word() ), @domain_suffix() ].join('.')

  domain_word: ->
    Faker.Util.fix_non_word_chars(Faker.Company.name().split(' ')[0]).toLowerCase()

  domain_suffix: ->
    Faker.Locale.sample('internet.domain_suffix')

  ip_v4_address: ->
    range   = Faker.Util.Numbers.range(2,254)
    address = []
    for i in [1..4]
      address.push Faker.Util.Random.sample(range)

    address.join('.')

  slug: (words, glue) ->
    glue  or= Faker.Util.Random.sample(['-','_','.'])
    words or= Faker.Lorem.words(2).join(' ')
    words.split(/\s+/gi).join(glue).toLowerCase()

Faker.PhoneNumber = Faker.extend
  phone_number: ->
    Faker.Util.interpret(Faker.Locale.sample('phone_number.formats'))

  toll_free: ->

Faker.Util = 
  isBlank: (object) ->
    ($.isPlainObject(object) and $.isEmptyObject(object)) or
    ($.isArray(object) and object.length == 0) or
    ($.type(object) == "string" and $.trim(object) == "") or
    (!object)

  isPresent: ->
   !@isBlank.apply(@, arguments)

  interpret: (raw) ->
    alpha_templates = raw.match(/(?:(#{[a-zA-Z\.\-\_]+})|(#(?!{)))/gi) or []
    # numberic_templates = raw.match(/(#(?!{))/gi) or []
    blocksToInterpret = alpha_templates #.concat(numberic_templates)
    
    $.each(blocksToInterpret, (index, elm) ->
      key = elm.replace(/[#{}\s]/gi, '')
      raw = raw.replace elm, Faker.Locale.sample(key) if key.match(/^(?:(?:[a-zA-Z\-\_]+)\.?)+[a-zA-Z]+$/)
      raw = $.mapConcat raw, (char) ->
        char.replace /#(?!{)/gi, Faker.Util.Numbers.sample(0,9)
    )
    raw

  fix_umlauts: (string) ->
    $.arrayReplace(string, ["ä", 'ae'], ["ö", 'oe'], ["ü", 'ue'], ["ß", 'ss'])

  fix_non_word_chars: (string) ->
    string.replace(/\W/gi, '')

Faker.Util.Random = 
  bool: ->
    (Math.floor(Math.random()*11) % 2) == 1

  sample: (collection, size) ->
    shuffled = collection.slice(0)
    i = collection.length
    size ?= 1

    while i--
      index = Math.floor(i * Math.random())
      temp  = shuffled[index]
      shuffled[index] = shuffled[i]
      shuffled[i] = temp

    if size > 1 then shuffled.slice(0, size) else shuffled.slice(0,1)[0]

Faker.Util.Numbers = 
  range: (start, end) ->
    range = []
    for i in [start..end]
      range.push i
    range

  sample: (start, end) ->
    Faker.Util.Random.sample(@range.apply(@, arguments))

Faker.Util.Alpha = 
  range: (start, end) ->
    chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')
    range = []
    start = $.inArray(start, chars)
    end   = $.inArray(end, chars)

    for index in [start..end]
      range.push chars[index]
    range

  sample: (start, end) ->
    Faker.Util.Random.sample(@range.apply(@, arguments))

Faker.Locale = 
  sample: (key, size) ->
    collection = this.collection(key)
    Faker.Util.Random.sample(collection, size)

  collection: (key) ->

    collection = Faker.Locales[Faker.config.locale]
    arrPath    = key.split(".")

    for i in [0...arrPath.length]
      collection = collection[arrPath[i]]

    $.error "Unknown key: \"#{key.toString()}\" -- you may need to scope it to the proper locale library (ex: name.first_name)" if Faker.Util.isBlank(collection)

    collection

  register: (id, collection) ->
    Faker.Locales[id] = collection
    return

  extend: ->
    Faker.Locales[id] ?= {}
    $.extend(true, Faker.Locales[id], collection)

Faker.Locales = {}
Faker.init()

# bind it to the global namespace
window.Faker = Faker

$.fn.faker = ->
  @.each ->

$.arrayReplace = (str, args...) ->
  rtn = str
  for set in args
    rtn = rtn.replace(new RegExp(set[0], 'gi'), set[1])
  rtn

$.mapConcat = (str, args...) ->
  separator = args.slice(0,1) if $.type(args[0]) == 'string' or $.type(args[0]) == 'regexp'
  separator or= ''
  chars = str.split(separator)
  rtn = []
  for char, i in chars
    rtn.push(args[0].call(str, char, i) or char)
 
  rtn.join('')