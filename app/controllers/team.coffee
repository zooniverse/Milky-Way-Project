Controller = require 'zooniverse/controllers/base-controller'

class Team extends Controller
  className: 'team-page'
  template: require '../views/team'

module.exports = Team
