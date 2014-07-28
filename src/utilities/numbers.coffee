Faker.Util.Numbers =
  range: (start, end) ->
    range = []
    for i in [start..end]
      range.push i
    range

  sample: (start, end) ->
    Faker.Util.Random.sample(@range.apply(@, arguments))

Faker.numbers = Faker.Util.Numbers
