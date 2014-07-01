module.exports = (grunt) ->
  grunt.file.defaultEncoding = 'utf8'
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    coffee:
      compile:
        options:
          join: true
          bare: true
        files:
          'dist/<%= pkg.name %>.js': [
            "src/base.coffee",
            "src/util.coffee",
            "src/locale.coffee",
            "src/extensions/*.coffee",
            "src/integrations/*.coffee",
            "src/locales/*.coffee"
          ]
          'test/spec/<%= pkg.name %>.spec.js': [
            'test/spec/faker.spec.coffee'
          ]

    uglify:
      options:
        banner: "/*! <%= pkg.name %> <%= grunt.template.today(\"dd-mm-yyyy\") %> */\n"

      dist:
        files:
          "dist/<%= pkg.name %>.min.js": ["dist/<%= pkg.name %>.js"]

    watch:
      scripts:
        options:
          atBegin: true
          livereload: true

        files: ['Gruntfile.coffee', 'src/**/*.coffee', 'test/spec/**/*.coffee']
        tasks: ["coffee", "uglify"]

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-jasmine"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-watch"

  grunt.registerTask "default", ["coffee", "uglify"]