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

Faker.random = Faker.Util.Random
