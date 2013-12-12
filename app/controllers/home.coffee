Controller = require 'zooniverse/controllers/base-controller'
Api = require 'zooniverse/lib/api'

formatNumber = (n) ->
  # TODO: Localize this.
  n.toString().replace /(\d)(?=(\d{3})+(?!\d))/g, '$1,'

class Home extends Controller
  className: 'home-page'
  template: require '../views/home'

  elements:
    '.counter-value': 'counterValues'

  constructor: ->
    super
    Api.current.get '/projects/milky_way', @onProjectLoad

  onProjectLoad: (project) =>
    for name in ['classification', 'bubble', 'cluster', 'ego', 'galaxy']
      @counterValues.filter(".#{name}").html formatNumber project["#{name}_count"] || '0'

module.exports = Home
