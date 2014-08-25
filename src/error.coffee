class Faker.Error
  constructor: (error) ->
    @error = error

  toString: ->
    @error.toString()

