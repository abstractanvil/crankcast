module.exports = (grunt) ->

  grunt.initConfig
    clean: ["./client-web/dist"]

    bower:
      install:
        options:
          targetDir: './client-web/dist/lib'

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

    imagemin:
      all:
        files: [
          {
            expand: true,
            cwd: './client-web/src/assets/images/',
            src: ['**/*.{png,jpg,gif}'],
            dest: './client-web/dist/assets/images/'
          }
        ]

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

      images:
        files: ['./client-web/src/app/assets/images/*.{png,jpg,gif}']
        tasks: ['imagemin']

      scripts:
        files: ['./client-web/src/app/scripts/*.coffee']
        tasks: ['coffee']

    connect:
      server:
        options:
          port: 3000,
          base: './client-web/dist'

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-bower-task'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-imagemin'
  grunt.loadNpmTasks 'grunt-contrib-coffee'

  grunt.registerTask 'dist', ['clean', 'bower', 'stylus', 'jade', 'coffee']
  grunt.registerTask 'serve', ['connect:server', 'watch']
  grunt.registerTask 'default', ['dist']
