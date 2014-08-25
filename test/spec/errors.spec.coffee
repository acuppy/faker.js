describe "Faker.Errors", ->
  describe "adding error strings to the collection", ->
    beforeEach ->
      @message_one = "Error message one"
      @message_two = "Error message two"

    it "includes both messages", ->
      Faker.Errors.add(@message_one)
      Faker.Errors.add(@message_two)
      expect(Faker.Errors.fullMessages()).toContain(@message_one, @message_two)
