$ = window.jQuery
$.noConflict()

PROBABLY_IOS = require './lib/probably-ios'
$(document.body).toggleClass 'probably-ios', PROBABLY_IOS

GoogleAnalytics = require 'zooniverse/lib/google-analytics'
new GoogleAnalytics
  account: 'UA-1224199-24'
  domain: 'milkywayproject.org'

t7e = require 't7e'
enUs = require './lib/en-us'

t7e.load enUs

# LanguageManager = require 'zooniverse/lib/language-manager'
# languageManager = new LanguageManager
#   translations:
#     en: label: 'English', strings: enUs
#     fr: label: 'Français', strings: './translations/fr.json'
#     pl: label: 'Polski', strings: './translations/pl.json'

# languageManager.on 'change-language', (e, code, languageStrings) ->
#   t7e.load languageStrings
#   t7e.refresh()

SiteHeader = require './controllers/site-header'
siteHeader = new SiteHeader
siteHeader.el.appendTo document.body

Api = require 'zooniverse/lib/api'
api = new Api project: 'milky_way'

TopBar = require 'zooniverse/controllers/top-bar'
topBar = new TopBar
topBar.el.appendTo document.body

Subject = require 'zooniverse/models/subject'
Subject.group = true
Subject.fallback = './offline-subjects.json'

StackOfPages = require 'stack-of-pages'
stack = new StackOfPages
  DEFAULT: '#/'
  '#/': require './controllers/home'
  '#/classify': require './controllers/classify'
  '#/subject/:id': require './controllers/subject'
  '#/science': require './controllers/science'
  '#/team': require './controllers/team'
  '#/data': require './controllers/data'
  '#/guide': require './controllers/guide'
  '#/faq': require './controllers/faq'
  NOT_FOUND: require './controllers/not-found'

document.body.appendChild stack.el

footerContainer = document.createElement 'div'
footerContainer.className = 'inverted site-footer-container'

Footer = require 'zooniverse/controllers/footer'
footer = new Footer
document.body.appendChild footerContainer
footer.el.appendTo footerContainer

User = require 'zooniverse/models/user'
User.fetch()

attachFastClick = require 'fastclick'
try attachFastClick document.body

window.app = module.exports = {siteHeader, api, topBar, stack}
