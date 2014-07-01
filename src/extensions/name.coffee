Faker.Name = Faker.extend
  full_name: ->
    name = new Array();
    name.push this.prefix() if Faker.Util.Random.bool()
    name.push this.first_name()
    name.push this.last_name()
    name.push this.suffix() if Faker.Util.Random.bool()
    name.join(' ')

  prefix: ->
    Faker.Locale.sample('name.prefix')

  first_name: ->
    Faker.Locale.sample('name.first_name')

  last_name: ->
    Faker.Locale.sample('name.last_name')

  suffix: ->
    Faker.Locale.sample('name.suffix')

  title: ->
    title = new Array()
    title.push Faker.Locale.sample('name.title.descriptor')
    title.push Faker.Locale.sample('name.title.level')
    title.push Faker.Locale.sample('name.title.job')
    title.join(' ')