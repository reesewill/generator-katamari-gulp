'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');
var chalk = require('chalk');


var KatamariGulpGenerator = yeoman.generators.Base.extend({
  init: function () {
    this.pkg = require('../package.json');

    this.on('end', function () {
      if (!this.options['skip-install']) {
        this.installDependencies();
      }
    });
  },

  askFor: function () {
    var done = this.async();

    // have Yeoman greet the user
    this.log(this.yeoman);

    // replace it with a short and sweet description of your generator
    this.log(chalk.magenta('You\'re using the fantastic KatamariGulp generator.'));

    var prompts = [{
      name: 'projectName',
      message: "Please enter your project's name.",
    }];

    this.prompt(prompts, function (props) {
      this.projectName = props.projectName;

      done();
    }.bind(this));
  },

  app: function () {
    this.mkdir('dist');
    this.mkdir('src');
    this.mkdir('src/common');
    this.mkdir('src/common/js');
    this.mkdir('src/common/js/libs');
    this.mkdir('src/common/css');
    this.mkdir('src/common/images');
    this.mkdir('src/common/css/helpers');
    this.mkdir('src/common/css/quarks');
    this.mkdir('src/common/css/atoms');
    this.mkdir('src/common/css/molecules');
    this.mkdir('src/views');
    this.mkdir('src/views/_partials');
    this.mkdir('src/views/_templates');

    this.template('_package.json', 'package.json');
    this.template('gulpfile.coffee', 'gulpfile.coffee');
    this.template('src/index.jade', 'src/index.jade');
    this.template('src/layout.jade', 'src/views/layout.jade');
    this.copy('src/jquery.min.js', 'src/common/js/libs/jquery.min.js');
    this.copy('src/fallback.min.js', 'src/common/js/libs/fallback.min.js');
    this.copy('src/index.coffee', 'src/common/js/main.coffee');
    this.copy('src/index.styl', 'src/common/css/all.styl');
    this.copy('src/_colors.styl', 'src/common/css/helpers/_colors.styl');
    this.copy('src/_reset.styl', 'src/common/css/quarks/_reset.styl');
    this.copy('src/_clearfix.styl', 'src/common/css/quarks/_clearfix.styl');
    this.copy('_gitignore', '.gitignore');
  },

  projectfiles: function () {
    this.copy('editorconfig', '.editorconfig');
    this.copy('jshintrc', '.jshintrc');
  }
});

module.exports = KatamariGulpGenerator;
