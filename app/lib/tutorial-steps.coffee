translate = require 't7e'
GhostMouse = require 'ghost-mouse'

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
    content: translate 'div', 'tutorial.first.content'
    next: ->
      if @classifier.surface.tool::name is 'bubble'
        'markBubble'
      else
        'selectBubbleTool'

  selectBubbleTool:
    content: translate 'div', 'tutorial.selectBubbleTool.content'
    instruction: translate 'div', 'tutorial.selectBubbleTool.instruction'
    attachment: [0.5, 1, 'input[name="tool"][value="bubble"] + *', 0.5, 0]
    arrow: 'bottom'
    actionable: 'input[name="tool"][value="bubble"] + *'
    next: 'change input[name="tool"][value="bubble"]': 'markBubble'

  markBubble:
    content: translate 'div', 'tutorial.markBubble.content'
    instruction: translate 'div', 'tutorial.markBubble.instruction'
    attachment: [0, 0.5, '.marking-surface', 0.45, 0.75]
    arrow: 'left'

    onLoad: ->
      @guide = @classifier.surface.addShape 'ellipse',
        rx: 110
        ry: 90
        transform: 'translate(210, 290), rotate(40)'
      @guide.attr guideStyle

    demo: ->
      ghostMouse.run ->
        @move '.marking-surface', (210 / 800), (290 / 400)
        @drag '.marking-surface', ((210 + 90) / 800), ((290 - 50) / 400)

    next:
      'mouseup .marking-surface': 'adjustBubbleMarking'
      'touchend .marking-surface': 'adjustBubbleMarking'

  adjustBubbleMarking:
    content: translate 'div', 'tutorial.adjustBubbleMarking.content'
    instruction: translate 'div', 'tutorial.adjustBubbleMarking.instruction'
    attachment: [0.33, 0.67, '.marking-surface', 0.25, 0.25]
    arrow: 'bottom'

    onUnload: ->
      @guide.remove()

    next:
      'mouseup .marking-surface': 'selectClusterTool'
      'touchend .marking-surface': 'selectClusterTool'

  selectClusterTool:
    content: translate 'div', 'tutorial.selectClusterTool.content'
    instruction: translate 'div', 'tutorial.selectClusterTool.instruction'
    attachment: [0.5, 1, 'input[name="tool"][value="cluster"] + *', 0.5, 0]
    arrow: 'bottom'
    actionable: 'input[name="tool"][value="cluster"] + *'

    next: 'change input[name="tool"][value="cluster"]': 'markCluster'

  markCluster:
    content: translate 'div', 'tutorial.markCluster.content'
    instruction: translate 'div', 'tutorial.markCluster.instruction'
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

    onUnload: ->
      @guide.remove()

    next:
      'mouseup .marking-surface': 'selectEgoTool'
      'touchend .marking-surface': 'selectEgoTool'

  selectEgoTool:
    content: translate 'div', 'tutorial.selectEgoTool.content'
    instruction: translate 'div', 'tutorial.selectEgoTool.instruction'
    attachment: [0.5, 1, 'input[name="tool"][value="ego"] + *', 0.5, 0]
    arrow: 'bottom'
    actionable: 'input[name="tool"][value="ego"] + *'

    next: 'change input[name="tool"][value="ego"]': 'markEgo'

  markEgo:
    content: translate 'div', 'tutorial.markEgo.content'
    instruction: translate 'div', 'tutorial.markEgo.instruction'
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

    onUnload: ->
      @guide.remove()

    next:
      'mouseup .marking-surface': 'callOutTalk'
      'touchend .marking-surface': 'callOutTalk'

  callOutTalk:
    content: translate 'div', 'tutorial.callOutTalk.content'
    attachment: [0, 0.5, 'a.discuss', 1, 0.5]
    arrow: 'left'
    next: 'callOutFavorite'

  callOutFavorite:
    content: translate 'div', 'tutorial.callOutFavorite.content'
    attachment: [0, 0.5, 'button[name="favorite"]', 1, 0.5]
    arrow: 'left'
    next: 'callOutHelp'

  callOutHelp:
    content: translate 'div', 'tutorial.callOutHelp.content'
    attachment: [0, 0.5, 'button[name="help"]', 1, 0.5]
    arrow: 'left'
    next: 'theEnd'

  theEnd:
    content: translate 'div', 'tutorial.theEnd.content'

module.exports = tutorialSteps
