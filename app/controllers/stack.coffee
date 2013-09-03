Controller = require 'zooniverse/controllers/base-controller'

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

    foundMatch = false

    for hash, controller of @routes
      paramsOrder = ['hash']

      hashSegments = hash.split '/'

      hashPatternSegments = for segment in hashSegments
        if segment.charAt(0) is ':'
          paramsOrder.push segment[1...]
          '([^\/]+)'
        else
          segment

      hashPattern = "^#{hashPatternSegments.join '/'}$"

      matches = currentHash.match hashPattern

      controller.el.toggle matches?

      if matches?
        foundMatch = true

        params = {hashPattern}
        for param, i in paramsOrder
          params[param] = matches[i]

        controller.activate? params

    unless foundMatch
      @routes.notFound?.el.toggle true
      @routes.notFound?.activate?()

module.exports = Stack
