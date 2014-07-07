Faker.Lorem = Faker.extend
  word: ->
    @sample("lorem.words")

  words: (qty) ->
    $.error "Quantity must be a valid integer" unless $.isNumeric qty
    @sample "lorem.words", qty

  characters: (qty, asArray) ->
    $.error("Quantity must be a valid integer") unless $.isNumeric(qty)
    arr = @sample("lorem.characters", qty)
    if asArray == true then arr else arr.join('')

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
    asArray  = false
    sentences = new Array()

    if args.length > 0 and $.type(args[args.length - 1]) == 'boolean'  then asArray = args[args.length - 1]
    if $.isArray(args) and args.length > 0 and $.isPlainObject args[0] then $.extend options, args[0]

    for i in [0...qty]
      sentences.push @sentence options

    if asArray == true then sentences else sentences.join ' '

  paragraph: (sentences, options) ->
    sentences ?= 3
    options   ?= {}

    $.error "First argument must be a valid integer" unless $.isNumeric sentences

    @sentences sentences, options

  paragraphs: (qty) ->
    $.error "Quantity must be a valid integer" unless $.isNumeric qty

    args      = Array.prototype.slice.call arguments, 1
    options   = {}
    asArray  = false
    paragraphs = new Array()

    if args.length > 0 and $.type(args[args.length - 1]) == 'boolean' then asArray = args[args.length - 1]
    if $.isArray args and args.length > 0 and $.isPlainObject args[0] then $.extend options, args[0]

    for i in [0...qty]
      paragraphs.push @paragraph 3, options

    if asArray == true then paragraphs else paragraphs.join(' ')
