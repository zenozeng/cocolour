module.exports = (grunt) ->
  grunt.initConfig
    stylus:
      compile:
        files:
          "static/styles.css": "static/stylus/*.styl"
    uglify:
      main:
        files:
          "js/main.min.js": "js/main.js"
    coffeeify:
      options:
        debug: true
      main:
        files: [
          {
            src: ["src/index.coffee"],
            dest: "js/main.js"
          }
        ]
    watch:
      scripts:
        files: ["src/*.coffee", "static/stylus/*.styl"]
        tasks: ["build"],

  ["uglify", "watch", "stylus"].map (name) ->
    grunt.loadNpmTasks "grunt-contrib-#{name}"
  grunt.loadNpmTasks "grunt-coffeeify"

  grunt.registerTask "build", ["stylus", "coffeeify", "uglify"]
