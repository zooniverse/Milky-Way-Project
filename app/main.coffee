$ = window.jQuery
$.noConflict()

t7e = require 't7e'
t7e.load require './lib/en-us'

SiteHeader = require './controllers/site-header'
siteHeader = new SiteHeader
siteHeader.el.appendTo document.body

Api = require 'zooniverse/lib/api'
api = new Api # project: 'milky_way'

TopBar = require 'zooniverse/controllers/top-bar'
topBar = new TopBar
topBar.el.appendTo document.body

Subject = require 'zooniverse/models/subject'
Subject.group = false
Subject.fallback = './offline-subjects.json'

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

document.body.appendChild stack.el

User = require 'zooniverse/models/user'
User.fetch()

window.app = module.exports = {siteHeader, api, topBar, stack}
