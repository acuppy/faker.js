Faker.Name = Faker.extend
  fullName: ->
    name = new Array()
    name.push @prefix() if Faker.Util.Random.bool()
    name.push @firstName()
    name.push @lastName()
    name.push @suffix() if Faker.Util.Random.bool()
    name.join(' ')

  prefix: ->
    @sample('name.prefix')

  firstName: ->
    @sample('name.firstName')

  lastName: ->
    @sample('name.lastName')

  suffix: ->
    @sample('name.suffix')

  title: ->
    title = new Array()
    title.push @sample('name.title.descriptor')
    title.push @sample('name.title.level')
    title.push @sample('name.title.job')
    title.join(' ')
