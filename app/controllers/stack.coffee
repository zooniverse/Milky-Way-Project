Controller = require 'zooniverse/controllers/base-controller'
$ = window.jQuery

class Stack extends Controller
  defaultHash: '#/'
  routes: null

  className: 'stack'

  constructor: ->
    super

    for hash, controllerClass of @routes
      instance = new controllerClass
      @routes[hash] = instance
      @el.append instance.el

    addEventListener 'hashchange', @onHashChange
    @onHashChange()

  onHashChange: =>
    currentHash = location.hash || @defaultHash
    for hash, controller of @routes
      controller.el.toggle hash is currentHash

module.exports = Stack
