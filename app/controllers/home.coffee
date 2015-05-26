Controller = require 'zooniverse/controllers/base-controller'
Api = require 'zooniverse/lib/api'
Subject = require 'zooniverse/models/subject'

FORCE_OTHER_PROJECT_PROMO = true

formatNumber = (n) ->
  # TODO: Localize this.
  n.toString().replace /(\d)(?=(\d{3})+(?!\d))/g, '$1,'

class Home extends Controller
  className: 'home-page'
  template: require '../views/home'

  elements:
    '.other-projects': 'otherProjects'
    '.counter-value': 'counterValues'

  constructor: ->
    super
    Api.current.get '/projects/milky_way', @onProjectLoad

    Subject.on 'no-more', @toggleOtherProjectPromo
    Subject.on 'select', @toggleOtherProjectPromo

  onProjectLoad: (project) =>
    for name in ['classification', 'bubble', 'cluster', 'ego', 'galaxy']
      @counterValues.filter(".#{name}").html formatNumber project["#{name}_count"] || '0'

  toggleOtherProjectPromo: (e, subject) =>
    @otherProjects.toggleClass 'active', !subject? || FORCE_OTHER_PROJECT_PROMO

module.exports = Home
