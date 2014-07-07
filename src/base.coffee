$ = jQuery

Faker = {}
Faker.Base =
  config: {}
  reset: ->
    @configure {}
    @

  configure: (configs) ->
    $.error "Hash expected -- received #{$.type(configs)}" unless $.isPlainObject(configs)

    baseConfig = locale: 'en'

    @config = $.extend(true, {}, baseConfig, configs)
    @

  extend: (extension) ->
    $.extend(true, {}, @, extension || {})

Faker.Base.init = Faker.Base.reset
