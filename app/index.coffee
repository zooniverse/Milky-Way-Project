$ = window.jQuery
$.noConflict()

Api = require 'zooniverse/lib/api'
api = new Api project: 'worms' # TODO

TopBar = require 'zooniverse/controllers/top-bar'
topBar = new TopBar

Navigation = require './controllers/navigation'
nav = new Navigation

Stack = require './controllers/stack'
stack = new Stack
  routes:
    '#/': require './controllers/home'
    '#/classify': require './controllers/classify'

User = require 'zooniverse/models/user'
User.fetch()

topBar.el.appendTo document.body
nav.el.appendTo document.body
stack.el.appendTo document.body

window.app = module.exports = {api, topBar, nav, stack}
