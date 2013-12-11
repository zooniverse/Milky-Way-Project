translate = require 't7e'
GhostMouse = require 'ghost-mouse'
User = require 'zooniverse/models/user'

isAbout = ([x, y], [idealX, idealY], give = 50) ->
  idealX - give < x < idealX + give and idealY - give < y < idealY + give

guideStyle =
  fill: 'transparent'
  stroke: 'white'
  strokeWidth: 2
  strokeDasharray: [4, 4]

ghostMouse = new GhostMouse
  events: true
  inverted: true

tutorialSteps =
  first:
    content: translate 'span', 'tutorial.first.content'
    next: ->
      if @classifier.surface.tool::name is 'bubble'
        'markBubble'
      else
        'selectBubbleTool'

  selectBubbleTool:
    content: translate 'span', 'tutorial.selectBubbleTool.content'
    instruction: translate 'span', 'tutorial.selectBubbleTool.instruction'
    attachment: [0.5, 1, '[name="tool"][value="bubble"]', 0.5, 0]
    arrow: 'bottom'
    actionable: '[name="tool"][value="bubble"]'
    next: 'click [name="tool"][value="bubble"]': 'markBubble'

  markBubble:
    content: translate 'span', 'tutorial.markBubble.content'
    instruction: translate 'span', 'tutorial.markBubble.instruction'
    attachment: [0, 0.5, '.marking-surface', 0.45, 0.75]
    arrow: 'left'

    onLoad: ->
      @guide = @classifier.surface.addShape 'ellipse',
        rx: 110
        ry: 90
        transform: 'translate(210, 290), rotate(40)'
      @guide.attr guideStyle

      @extantMarks = (mark for mark in @classifier.surface.marks)

    demo: ->
      ghostMouse.run ->
        @move '.marking-surface', (210 / 800), (290 / 400)
        @drag '.marking-surface', ((210 + 90) / 800), ((290 - 50) / 400)

    next:
      'mouseup .marking-surface': ->
        newMarks = (mark for mark in @classifier.surface.marks when mark not in @extantMarks)

        if newMarks.some((mark) -> isAbout mark.center, [210, 290])
          'adjustBubbleMarking'
        else
          false

      'touchend .marking-surface': ->
        @._current.next['mouseup .marking-surface'].apply @, arguments

  adjustBubbleMarking:
    content: translate 'span', 'tutorial.adjustBubbleMarking.content'
    instruction: translate 'span', 'tutorial.adjustBubbleMarking.instruction'
    attachment: [0.33, 0.67, '.marking-surface', 0.25, 0.25]
    arrow: 'bottom'

    onUnload: ->
      @guide.remove()

    next:
      'mouseup .marking-surface': 'selectClusterTool'
      'touchend .marking-surface': 'selectClusterTool'

  selectClusterTool:
    content: translate 'span', 'tutorial.selectClusterTool.content'
    instruction: translate 'span', 'tutorial.selectClusterTool.instruction'
    attachment: [0.5, 1, '[name="tool"][value="cluster"]', 0.5, 0]
    arrow: 'bottom'
    actionable: '[name="tool"][value="cluster"]'

    next: 'click [name="tool"][value="cluster"]': 'markCluster'

  markCluster:
    content: translate 'span', 'tutorial.markCluster.content'
    instruction: translate 'span', 'tutorial.markCluster.instruction'
    attachment: [1, 0.5, '.marking-surface', 0.6, 0.3]
    arrow: 'right'

    demo: ->
      ghostMouse.run ->
        @move '.marking-surface', (560 / 800), (120 / 400)
        @drag '.marking-surface', (580 / 800), (180 / 400)

    onLoad: ->
      @guide = @classifier.surface.addShape 'circle',
        r: 60
        transform: 'translate(550, 120)'
      @guide.attr guideStyle

      @extantMarks = (mark for mark in @classifier.surface.marks)

    onUnload: ->
      @guide.remove()

    next:
      'mouseup .marking-surface': ->
        newMarks = (mark for mark in @classifier.surface.marks when mark not in @extantMarks)

        if newMarks.some((mark) -> isAbout mark.center, [560, 120])
          'selectEgoTool'
        else
          false

      'touchend .marking-surface': ->
        @._current.next['mouseup .marking-surface'].apply @, arguments

  selectEgoTool:
    content: translate 'span', 'tutorial.selectEgoTool.content'
    instruction: translate 'span', 'tutorial.selectEgoTool.instruction'
    attachment: [0.5, 1, '[name="tool"][value="ego"]', 0.5, 0]
    arrow: 'bottom'
    actionable: '[name="tool"][value="ego"]'

    next: 'click [name="tool"][value="ego"]': 'markEgo'

  markEgo:
    content: translate 'span', 'tutorial.markEgo.content'
    instruction: translate 'span', 'tutorial.markEgo.instruction'
    attachment: [0.5, 0, '.marking-surface', (275 / 800), (75 / 400)]
    arrow: 'top'

    demo: ->
      ghostMouse.run ->
        @move '.marking-surface', (275 / 800), (30 / 400)
        @drag '.marking-surface', (280 / 800), (55 / 400)

    onLoad: ->
      @guide = @classifier.surface.addShape 'circle',
        r: 15
        transform: 'translate(275, 30)'
      @guide.attr guideStyle

      @extantMarks = (mark for mark in @classifier.surface.marks)

    onUnload: ->
      @guide.remove()

    next:
      'mouseup .marking-surface': ->
        newMarks = (mark for mark in @classifier.surface.marks when mark not in @extantMarks)

        if newMarks.some((mark) -> isAbout mark.center, [275, 30], 25)
          'callOutTalk'
        else
          false

      'touchend .marking-surface': ->
        @._current.next['mouseup .marking-surface'].apply @, arguments

  callOutTalk:
    content: translate 'span', 'tutorial.callOutTalk.content'
    attachment: [0, 0.5, 'a.discuss', 1, 0.5]
    arrow: 'left'
    next: ->
      if User.current?
        'callOutFavorite'
      else
        'callOutSignIn'

  callOutSignIn:
    content: translate 'span', 'tutorial.callOutSignIn.content'
    attachment: [0, 0.5, '.classify button[name="sign-in"]', 1, 0.5]
    arrow: 'left'
    next: 'callOutHelp'

  callOutFavorite:
    content: translate 'span', 'tutorial.callOutFavorite.content'
    attachment: [0, 0.5, '.classify button[name="favorite"]', 1, 0.5]
    arrow: 'left'
    next: 'callOutHelp'

  callOutHelp:
    content: translate 'span', 'tutorial.callOutHelp.content'
    attachment: [0, 0.5, '.classify button[name="help"]', 1, 0.5]
    arrow: 'left'
    next: 'markStuff'

  markStuff:
    content: translate 'span', 'tutorial.markStuff.content'
    next: 'theEnd'

  theEnd:
    content: translate 'span', 'tutorial.theEnd.content'

module.exports = tutorialSteps
