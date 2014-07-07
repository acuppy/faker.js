Faker.PhoneNumber = Faker.extend
  phoneNumber: ->
    Faker.Util.interpret @sample('phoneNumber.formats')

  tollFree: ->
