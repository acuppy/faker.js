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

    $.each(blocksToInterpret, (index, elm) =>
      key = elm.replace(/[#{}\s]/gi, '')
      raw = raw.replace elm, Faker.Locale.sample(key) if key.match(/^(?:(?:[a-zA-Z\-\_]+)\.?)+[a-zA-Z]+$/)
      raw = @mapConcat raw, (char) ->
        char.replace /#(?!{)/gi, Faker.Util.Numbers.sample(0,9)
    )
    raw

  fix_umlauts: (string) ->
    @arrayReplace(string, ["ä", 'ae'], ["ö", 'oe'], ["ü", 'ue'], ["ß", 'ss'])

  fix_non_word_chars: (string) ->
    string.replace(/\W/gi, '')

  mapConcat: (str, args...) ->
    separator = args.slice(0,1) if $.type(args[0]) == 'string' or $.type(args[0]) == 'regexp'
    separator or= ''
    chars = str.split(separator)
    rtn = []
    for char, i in chars
      rtn.push(args[0].call(str, char, i) or char)

    rtn.join('')

  arrayReplace: (str, args...) ->
    rtn = str
    for set in args
      rtn = rtn.replace(new RegExp(set[0], 'gi'), set[1])
    rtn

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