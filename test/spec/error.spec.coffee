describe "Faker.Error", ->
  beforeEach ->
    @message = "An error"
    @error = new Faker.Error(@message)

  it "accepts a list of error strings", ->
    expect(@error.toString()).toBe(@message)
