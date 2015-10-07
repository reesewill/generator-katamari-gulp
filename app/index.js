'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');
var chalk = require('chalk');


var KatamariGulpGenerator = yeoman.generators.Base.extend({
  init: function () {
    this.pkg = require('../package.json');

    // this.on('end', function () {
    //   if (!this.options['skip-install']) {
    //     this.installDependencies();
    //   }
    // });
  },

  askFor: function () {
    var done = this.async();

    // have Yeoman greet the user
    this.log(this.yeoman);

    // replace it with a short and sweet description of your generator
    this.log(chalk.magenta('You\'re using the fantastic KatamariGulp generator!'));

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
    this.mkdir('src/common/js/_etc');
    this.mkdir('src/common/css');
    this.mkdir('src/common/images');
    this.mkdir('src/common/sprite');
    this.mkdir('src/common/css/_helpers');
    this.mkdir('src/common/css/_quarks');
    this.mkdir('src/common/css/_atoms');
    this.mkdir('src/common/css/_molecules');
    this.mkdir('src/views');
    this.mkdir('src/views/_partials');
    this.mkdir('src/views/_templates');

    this.template('_package.json', 'package.json');
    this.copy('gulpfile.coffee', 'gulpfile.coffee');
    this.template('src/index.jade', 'src/index.jade');
    this.template('src/_layout.jade', 'src/views/_layout.jade');
    this.copy('src/jquery.min.js', 'src/common/js/libs/jquery.min.js');
    this.copy('src/jquery.mobile.min.js', 'src/common/js/libs/jquery.mobile.min.js');
    this.copy('src/polyfill.coffee', 'src/common/js/_etc/polyfill.coffee');
    this.copy('src/scroll.coffee', 'src/common/js/_etc/scroll.coffee');
    this.copy('src/index.coffee', 'src/common/js/main.coffee');
    this.copy('src/all.scss', 'src/common/css/all.scss');
    this.copy('src/colors.scss', 'src/common/css/_helpers/colors.scss');
    this.copy('src/constants.scss', 'src/common/css/_helpers/constants.scss');
    this.copy('src/layout.scss', 'src/common/css/_atoms/layout.scss');
    this.copy('src/reset.scss', 'src/common/css/_quarks/reset.scss');
    this.copy('src/clearfix.scss', 'src/common/css/_quarks/clearfix.scss');
    this.copy('src/headers.scss', 'src/common/css/_quarks/headers.scss');
    this.copy('src/list.scss', 'src/common/css/_quarks/list.scss');
    this.copy('src/links.scss', 'src/common/css/_quarks/links.scss');
    this.copy('src/retina-sprite.scss', 'src/common/css/_helpers/retina-sprite.scss');
    this.copy('_gitignore', '.gitignore');
  },

  projectfiles: function () {
    this.copy('editorconfig', '.editorconfig');
    this.copy('jshintrc', '.jshintrc');
  }
});

module.exports = KatamariGulpGenerator;
