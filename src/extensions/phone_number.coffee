Faker.PhoneNumber = Faker.extend
  phone_number: ->
    Faker.Util.interpret(Faker.Locale.sample('phone_number.formats'))

  toll_free: ->