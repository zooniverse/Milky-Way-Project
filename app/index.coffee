Navigation = require './controllers/navigation'
nav = new Navigation
nav.el.appendTo document.body

Home = require './controllers/home'
home = new Home
home.el.appendTo document.body

Classify = require './controllers/classify'
classify = new Classify
classify.el.appendTo document.body

window.app = module.exports = {nav, home, classify}
