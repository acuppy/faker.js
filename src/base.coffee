$ = jQuery

@.Faker.Base =
  config: {}
  reset: ->
    @configure {}
    return

  configure: (configs) ->
    $.error "Hash expected -- received #{$.type(configs)}" unless $.isPlainObject(configs)

    baseConfig =
      locale: 'en'

    @config = $.extend(true, {}, baseConfig, configs)
    return

  extend: (extension) ->
    $.extend(true, {}, this, extension || {})

@.Faker = $.extend(true, {}, @.Faker.Base)