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