module.exports = (grunt) ->
  grunt.initConfig
    stylus:
      compile:
        files:
          "static/styles.css": "static/stylus/*.styl"
    uglify:
      main:
        files:
          "static/main.min.js": "static/main.js"
    coffeeify:
      options:
        debug: true
      main:
        files: [
          {
            src: ["src/index.coffee"],
            dest: "static/main.js"
          }
        ]
    clean:
      js: ["static/main.js"]
    watch:
      scripts:
        options:
          livereload: true
        files: ["src/[^#]*.coffee", "static/stylus/*.styl"]
        tasks: ["build"],

  ["uglify", "watch", "stylus", "clean"].map (name) ->
    grunt.loadNpmTasks "grunt-contrib-#{name}"
  grunt.loadNpmTasks "grunt-coffeeify"

  grunt.registerTask "build", ["stylus", "coffeeify", "uglify", "clean"]
