Subject = require 'zooniverse/models/subject'

selectTutorialSubject = ->
  subject = new Subject
    id: '529e522e4d696359f4f09d00'
    coords: [-0.0468, 286.0532]
    group:
      _id: '523ca1a03ae74053b9000004'
      zooniverse_id: 'GMW0000002'
      name: 'velacar'
    group_id: '523ca1a03ae74053b9000004'
    location: standard: './images/tutorial-subject.jpg'
    metadata:
      file_name: 'GLM_286.0532-00.0468_mosaic_I124.jpg'
      size: '1.0000x0.5000'
    project_id: '523ca1a03ae74053b9000001'
    tutorial: true
    workflow_ids: ['523ca1a03ae74053b9000002']
    zooniverse_id: 'AMW0000v75'

  subject.select()

module.exports = selectTutorialSubject
