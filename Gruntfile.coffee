module.exports = (grunt) ->
  grunt.file.defaultEncoding = 'utf8'
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    coffee:
      compile:
        join: true
        files:
          'dist/<%= pkg.name %>.js': [
            "src/faker.coffee",
            "src/base.coffee",
            "src/util.coffee",
            "src/locale.coffee",
            "src/extensions/*.coffee",
            "src/integrations/*.coffee",
            "src/locales/*.coffee"
          ]

    uglify:
      options:
        banner: "/*! <%= pkg.name %> <%= grunt.template.today(\"dd-mm-yyyy\") %> */\n"

      dist:
        files:
          "dist/<%= pkg.name %>.min.js": ["dist/<%= pkg.name %>.js"]

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-uglify"

  grunt.registerTask "default", ["coffee", "uglify"]