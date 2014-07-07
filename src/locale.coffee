Faker.Locale =
  sample: (key, size) ->
    collection = @collection(key)
    Faker.Util.Random.sample(collection, size)

  collection: (key) ->

    collection = Faker.Locales[Faker.config.locale]
    arrPath    = key.split(".")

    for i in [0...arrPath.length]
      collection = collection[arrPath[i]]

    $.error "Unknown key: \"#{key.toString()}\" -- you may need to scope it to the proper locale library (e.g. \"name.first_name\")" if Faker.Util.isBlank(collection)

    collection

  register: (id, collection) ->
    Faker.Locales[id] = collection
    return

  extend: ->
    Faker.Locales[id] ?= {}
    $.extend(true, Faker.Locales[id], collection)

Faker.sample = Faker.Locale.sample
Faker.collection = Faker.Locale.collection
