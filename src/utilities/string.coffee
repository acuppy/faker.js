Faker.Util.String =
  fixUmlauts: ->
    @arrayReplace(["ä", 'ae'], ["ö", 'oe'], ["ü", 'ue'], ["ß", 'ss'])

  fixNonWordChars: ->
    @replace(/\W/gi, '')

  mapConcat: (args...) ->
    separator = args.slice(0,1) if $.type(args[0]) == 'string' or $.type(args[0]) == 'regexp'
    separator or= ''
    chars = @split(separator)
    rtn = []
    for char, i in chars
      rtn.push(args[0].call(@, char, i) or char)

    rtn.join('')

  arrayReplace: (args...) ->
    str = ''
    for set in args
      str += str.replace(new RegExp(set[0], 'gi'), set[1])
    str

Faker.string = Faker.Util.String