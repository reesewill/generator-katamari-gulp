_ = require 'underscore'
gulp = require 'gulp'
jade = require 'gulp-jade'
sass = require 'gulp-sass'
rename = require 'gulp-rename'
uglify = require 'gulp-uglify'
changed = require 'gulp-changed'
imagemin = require 'gulp-imagemin'
transform = require 'vinyl-transform'
sourcemaps = require 'gulp-sourcemaps'
browserify = require 'browserify'
browserSync = require 'browser-sync'
spritesmith = require 'gulp.spritesmith'
mediaqueries = require 'gulp-combine-media-queries'
plumber = require 'gulp-plumber'
watchify = require 'watchify'
pngcrush = require 'imagemin-pngcrush'
pngquant = require 'imagemin-pngquant'

expand = (ext)-> rename (path) -> _.tap path, (p) -> p.extname = ".#{ext}"
notify = (filename) -> console.log(filename)

environment = process.env.NODE_ENV or "development"

DEST = "./dist"
SRC = "./src"
CHANGED = "./__modified"

# ファイルタイプごとに無視するファイルなどを設定
paths =
    js: ["#{SRC}/**/*.coffee", "!#{SRC}/**/_**/*.coffee", "!#{SRC}/**/_*.coffee"]
    jsw: ["#{SRC}/**/*.coffee", "#{SRC}/views/_templates/*jade"]
    jslib: ["#{SRC}/**/*.js"]
    css: ["#{SRC}/**/*.scss", "!#{SRC}/**/sprite*.styl", "!#{SRC}/**/_**/*.scss", "!#{SRC}/**/_*.scss"]
    cssw: ["#{SRC}/**/*.scss"]
    img: ["#{SRC}/**/*.{png, jpg, gif}", "!#{SRC}/**/sprite/**/*.png"]
    html: ["#{SRC}/**/*.jade", "!#{SRC}/**/_**/*.jade", "!#{SRC}/**/_*.jade"]
    htmlw: ["#{SRC}/**/*.jade"]
    reload: ["#{DEST}/**/*", "!#{DEST}/**/*.css"]
    sprite: "#{SRC}/**/sprite/**/*.png"

gulp.task 'browserify', ->

  bundler = (options) ->
    transform (filename) ->
      b = browserify _.extend options, {}#watchify.args

      # watch
      #b = watchify b
      b.add filename

      # transform
      b.transform 'coffeeify'
      b.transform 'jadeify'
      b.transform 'stylify'
      b.transform 'debowerify'

      # events
      b.on 'bundle', notify.bind null, 'BUNDLE ' + filename
      b.on 'error', -> console.log "error"
      b.on 'log', -> console.log arguments
      b.on 'update', ->
        console.log "asdasd"
        bundle()

      b.bundle()

  bundle = ->
    gulp.src paths.js
      .pipe plumber()
      .pipe bundler extensions: ['.coffee']
      .pipe expand "js"
      #.pipe uglify()
      .pipe gulp.dest DEST
      .pipe gulp.dest CHANGED

  bundle()
        
gulp.task "js", ->
    
    gulp.src paths.jslib
        .pipe gulp.dest DEST

gulp.task "sass", ["sprite"], ->
  
  if environment is "production"
    gulp.src paths.css
      .pipe plumber()
      .pipe changed DEST
      .pipe sass()
      #.pipe mediaqueries()
      .pipe expand "css"
      .pipe gulp.dest DEST
      .pipe gulp.dest CHANGED
      .pipe browserSync.reload stream:true
  else
    gulp.src paths.css
      .pipe plumber()
      .pipe sourcemaps.init()
      .pipe sass()
      .pipe sourcemaps.write()
      .pipe gulp.dest DEST
      .pipe browserSync.reload stream:true

gulp.task "jade", ->
  gulp.src paths.html
    .pipe plumber()
    .pipe jade pretty: false
    .pipe expand "html"
    .pipe gulp.dest DEST
    .pipe gulp.dest CHANGED

gulp.task "imagemin", ->
  gulp.src paths.img
    .pipe imagemin
      use: [pngcrush(), pngquant()]
    .pipe gulp.dest DEST

gulp.task "browser-sync", ->
  browserSync
    #startPath: 'a.html'
    server: baseDir: DEST

# http://blog.e-riverstyle.com/2014/02/gulpspritesmithcss-spritegulp.html
gulp.task "sprite", ->
  a = gulp.src paths.sprite
    .pipe plumber()
    .pipe spritesmith
      imgName: 'common/images/sprite.png'
      cssName: 'common/images/sprite.styl'
      imgPath: '../images/sprite.png'
      algorithm: 'binary-tree'
      cssFormat: 'sass'
      padding: 4

  a.img.pipe gulp.dest SRC
  a.img.pipe gulp.dest DEST
  a.css.pipe gulp.dest SRC

gulp.task 'watch', ->
    gulp.watch paths.jsw, ['browserify']
    gulp.watch paths.cssw  , ['sass']
    gulp.watch paths.htmlw , ['jade']
    gulp.watch paths.sprite , ['sprite']
    gulp.watch paths.reload, -> browserSync.reload once: true

gulp.task "default", ['jade', 'sass', 'js', 'browserify', 'browser-sync', 'watch'] 
gulp.task "build", ['imagemin', 'sass', 'browserify', 'jade']
