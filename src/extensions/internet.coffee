Faker.Internet = Faker.extend
  email: ->
    [ @userName(), @domainName() ].join('@')

  freeEmail: ->
    [ @userName(), @sample('internet.freeEmail') ].join('@')

  safeEmail: ->
    [ @userName(), "example.#{Faker.Util.Random.sample(['com', 'net', 'org'])}" ].join('@')

  userName: ->
    samples = [
      (-> Faker.Util.fixNonWordChars(Faker.Name.firstName())),
      (-> $.map([ Faker.Name.firstName(), Faker.Name.lastName()], (elm, index) ->
          Faker.Util.fixNonWordChars(elm)).join('_').toLowerCase())
    ]

    Faker.Util.fixUmlauts( Faker.Util.Random.sample(samples).call() )

  domainName: ->
    [ Faker.Util.fixUmlauts( @domainWord() ), @domainSuffix() ].join('.')

  domainWord: ->
    Faker.Util.fixNonWordChars(Faker.Company.name().split(' ')[0]).toLowerCase()

  domainSuffix: ->
    @sample('internet.domainSuffix')

  ipV4Address: ->
    range   = Faker.Util.Numbers.range(2,254)
    address = []
    for i in [1..4]
      address.push Faker.Util.Random.sample(range)

    address.join('.')

  slug: (words, glue) ->
    glue  or= Faker.Util.Random.sample(['-','_','.'])
    words or= Faker.Lorem.words(2).join(' ')
    words.split(/\s+/gi).join(glue).toLowerCase()
