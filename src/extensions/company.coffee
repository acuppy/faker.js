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