Controller = require 'zooniverse/controllers/base-controller'
$ = window.jQuery

class Stack extends Controller
  className: 'stack'

  routes: null

  constructor: ->
    super

    for hash, controllerClass of @routes
      instance = new controllerClass
      @routes[hash] = instance
      @el.append instance.el

    addEventListener 'hashchange', @onHashChange
    @onHashChange()

  onHashChange: =>
    for hash, controller of @routes
      controller.el.toggle hash is location.hash

module.exports = Stack
