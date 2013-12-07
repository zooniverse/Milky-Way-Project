Subject = require 'zooniverse/models/subject'

selectTutorialSubject = ->
  subject = new Subject
    id: 'TUTORIAL_SUBJECT_ID'
    zooniverse_id: 'TUTORIAL_SUBJECT_ZOONIVERSE_ID'
    location: standard: './images/tutorial-subject.jpg'
    metadata: {}

    tutorial: true

  subject.select()

module.exports = selectTutorialSubject
