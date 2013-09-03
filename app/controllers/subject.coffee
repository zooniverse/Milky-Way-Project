Controller = require 'zooniverse/controllers/base-controller'

class Subject extends Controller
  activate: (params) ->
    console.log params
    @el.html "Params are #{JSON.stringify params}"

module.exports = Subject
