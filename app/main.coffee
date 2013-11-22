$ = window.jQuery
$.noConflict()

Api = require 'zooniverse/lib/api'
api = new Api project: 'milky_way'

TopBar = require 'zooniverse/controllers/top-bar'
topBar = new TopBar

Subject = require 'zooniverse/models/subject'
Subject.group = true

Navigation = require './controllers/navigation'
nav = new Navigation

StackOfPages = require 'stack-of-pages'
stack = new StackOfPages
  DEFAULT: '#/classify'
  '#/': require './controllers/home'
  '#/classify': require './controllers/classify'
  '#/subject/:id': require './controllers/subject'
  '#/science': require './controllers/science'
  '#/team': require './controllers/team'
  '#/data': require './controllers/data'
  NOT_FOUND: require './controllers/not-found'

User = require 'zooniverse/models/user'
User.fetch()

topBar.el.appendTo document.body
nav.el.appendTo document.body
document.body.appendChild stack.el

window.app = module.exports = {api, topBar, nav, stack}
