Controller = require 'zooniverse/controllers/base-controller'
T7eMenu = require 't7e/menu'

class Navigation extends Controller
  tagName: 'nav'
  className: 'main-nav'
  template: require '../views/navigation'

  elements:
    '.language-menu': 'languageMenuContainer'

  constructor: (params = {}) ->
    super

    t7eMenu = new T7eMenu
      languages:
        'en-US':
          label: 'U.S. English',
          value: require '../lib/en-us'

    @languageMenuContainer.append t7eMenu.select
    t7e.refresh @el.get 0

    addEventListener 'hashchange', @onHashChange
    @onHashChange()

  onHashChange: =>
    for a in @el.find 'a'
      $(a).toggleClass 'active', a.hash is location.hash

module.exports = Navigation
