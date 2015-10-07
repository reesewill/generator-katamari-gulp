_ = require 'underscore'
gulp = require 'gulp'
jade = require 'gulp-jade'
sass = require 'gulp-sass'
util = require 'gulp-util'
debug = require 'gulp-debug'
watch = require 'gulp-watch'
concat = require 'gulp-concat'
rename = require 'gulp-rename'
uglify = require 'gulp-uglify'
notify = require 'gulp-notify'
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
logfile = (filename) -> console.log(filename)

environment = process.env.NODE_ENV or "development"

DEST = "./dist"
SRC = "./src"
CHANGED = "./__modified"

# ファイルタイプごとに無視するファイルなどを設定
PATH_ = ""
paths =
  js: ["#{SRC}/**/*.coffee", "!#{SRC}/**/_**/*.coffee", "!#{SRC}/**/_*.coffee"]
  jsw: ["#{SRC}/**/*.coffee", "#{SRC}/views/_templates/*jade"]
  jslib: ["#{SRC}/**/*.js", "!#{SRC}/**/_*.js"]
  json: ["#{SRC}/**/*.json", "#{SRC}/**/_*.js"]
  css: ["#{SRC}/**/*.scss", "!#{SRC}/**/sprite*.styl", "!#{SRC}/**/_**/*.scss", "!#{SRC}/**/_*.scss"]
  cssw: ["#{SRC}/**/*.scss"]
  img: ["#{SRC}/**/*.{png, jpg, gif}", "!#{SRC}/**/sprite/**/*.png"]
  html: ["#{SRC}/**/*.jade", "!#{SRC}/**/_**/*.jade", "!#{SRC}/**/_*.jade"]
  htmlw: ["#{SRC}/**/*.jade"]
  reload: ["#{DEST}/**/*", "!#{DEST}/**/*.css"]
  sprite: "#{SRC}/**/sprite/**/*.png"

watch_hook = (path)->
  PATH_ =  path;
  border = "----------------------------------------" # border = "-".repeat(40)
  util.log(border);
  util.log(util.colors.yellow(PATH_));

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
      b.on 'bundle', logfile.bind null, 'BUNDLE ' + filename
      b.on 'error', -> console.log "error"
      b.on 'log', -> console.log arguments
      b.on 'update', ->
        console.log "asdasd"
        bundle()

      b.bundle()

  bundle = ->
    gulp.src paths.js
      .pipe debug()
      .pipe plumber({ errorHandler: notify.onError('<%= error.message %>')})
      .pipe bundler extensions: ['.coffee']
      .pipe expand "js"
      .pipe gulp.dest "#{DEST}"

  bundle()

gulp.task "json", ->

  gulp.src paths.json
    .pipe gulp.dest DEST

gulp.task "sass", ->

  if environment is "production"
    gulp.src paths.css
      .pipe plumber()
      .pipe changed DEST
      .pipe(sass.sync().on('error', (err) -> console.error('Error!', err.message)))
      #.pipe mediaqueries()
      .pipe expand "css"
      .pipe gulp.dest DEST
      .pipe browserSync.reload stream:true
  else
    gulp.src paths.css
      .pipe plumber()
      .pipe sourcemaps.init()
      .pipe(sass.sync().on('error', (err) -> console.error('Error!', err.message)))
      .pipe sourcemaps.write()
      .pipe gulp.dest DEST
      .pipe browserSync.reload stream:true

gulp.task "jade-all", ->
  PATH_ = paths.html
  gulp.start ["jade"]

gulp.task "jade", ->
  gulp.src PATH_
    .pipe plumber()
    .pipe jade pretty: false
    .pipe expand "html"
    .pipe gulp.dest DEST

gulp.task "imagemin", ->
  gulp.src paths.img
    .pipe imagemin
      use: [pngcrush(), pngquant()]
    .pipe gulp.dest DEST

gulp.task "js", ->
  gulp.src paths.jslib
    .pipe concat('libs.js')
    .pipe uglify()
    .pipe gulp.dest "#{DEST}/common/js/libs/"

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
      cssName: 'common/css/_helpers/sprite.scss'
      imgPath: '../images/sprite.png'
      algorithm: 'binary-tree'
      cssFormat: 'scss'
      padding: 2

  a.img.pipe gulp.dest SRC
  a.img.pipe gulp.dest DEST
  a.css.pipe gulp.dest SRC

gulp.task 'watch', ->
  gulp.watch paths.jsw, ['browserify']
  gulp.watch paths.cssw  , ['sass']
  # gulp.watch paths.htmlw , ['jade']
  gulp.watch paths.jslib, ['js']
  gulp.watch paths.reload, -> browserSync.reload once: true

  watch paths.htmlw, (e) ->
    watch_hook(e.path)
    gulp.start ["jade"]

gulp.task "default", ['jade-all', 'sass', 'js', 'json', 'browserify', 'browser-sync', 'watch']
gulp.task "build", ['imagemin', 'sass', 'js', 'json', 'browserify', 'jade-all']
