Faker.Util.Alpha =
  range: (start, end) ->
    chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')
    range = []
    start = $.inArray(start, chars)
    end   = $.inArray(end, chars)

    for index in [start..end]
      range.push chars[index]
    range

  sample: (start, end) ->
    Faker.Util.Random.sample(@range.apply(@, arguments))

Faker.alpha = Faker.Util.Alpha
