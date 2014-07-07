Faker.Company = Faker.extend
  name: ->
    Faker.Util.interpret @sample("company.name")

  suffix: ->
    @sample("company.suffix")

  catchPhrase: ->
    $.map(@collection("company.buzzwords"), (elm, i) ->
      Faker.Util.Random.sample(elm)
    ).join(' ')

  bs: ->
    $.map(@collection("company.bs"), (elm, i) ->
      Faker.Util.Random.sample(elm)
    ).join(' ')
