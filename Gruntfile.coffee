module.exports = (grunt) ->

  grunt.initConfig
    clean: ["./client-web/dist"]

    jade:
      compile:
        options:
          pretty: true
        files: [{
            cwd: './client-web/src/app',
            src: '*.jade',
            dest: './client-web/dist',
            expand: true,
            ext: '.html'
        }]

    stylus:
      compile:
        files:
          './client-web/dist/styles/style.css': ['./client-web/src/app/styles/*.styl']

    coffee:
      compile:
        files:
          './client-web/dist/scripts/app.js': ['./client-web/src/app/scripts/*.coffee']

    watch:
      jade:
        files: ['./client-web/src/app/**/*.jade']
        tasks: ['jade']

      styl:
        files: ['./client-web/src/app/styles/*.styl']
        tasks: ['stylus']

      scripts:
        files: ['./client-web/src/app/scripts/*.coffee']
        tasks: ['coffee']

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'

  grunt.registerTask 'dist', ['clean', 'stylus', 'jade', 'coffee']
  grunt.registerTask 'default', ['dist']
  grunt.registerTask 'heroku', ['default']
  
