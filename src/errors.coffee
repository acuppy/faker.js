Faker.Errors =
  add: (errors...)->
    $.each errors, (i, error) =>
      @_errors.push(new Faker.Error(error))

  fullMessages: ->
    $.map @_errors, (error) -> error.toString()

  toString: ->
    @fullMessages.join('; ')

  isBlank: ->
    Faker.Util.isBlank(@_errors)

  _errors: []

Faker.errors = Faker.Errors
