Controller = require 'zooniverse/controllers/base-controller'
Api = require 'zooniverse/lib/api'

class Home extends Controller
  className: 'home-page'
  template: require '../views/home'

  elements:
    '.counter-value': 'counterValues'

  constructor: ->
    super
    Api.current.get '/projects/milky_way', @onProjectLoad

  onProjectLoad: (project) =>
    # TODO
    console?.log project
    for name in ['classifications', 'bubbles', 'clusters', 'egos', 'galaxies']
      @counterValues.filter(".#{name}").html project.counts?[name] || '0'

module.exports = Home
