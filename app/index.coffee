T7eMenu = require 't7e/menu'
t7eMenu = new T7eMenu
  languages:
    'en-US':
      label: 'U.S. English',
      value: require './lib/en-us'

document.body.appendChild t7eMenu.select

Home = require './controllers/home'
home = new Home
home.el.appendTo document.body

Classify = require './controllers/classify'
classify = new Classify
classify.el.appendTo document.body

window.app = module.exports = {t7eMenu, home, classify}
