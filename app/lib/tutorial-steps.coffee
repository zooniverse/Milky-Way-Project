translate = require 't7e'

tutorialSteps =
  first:
    content: translate 'div', "tutorial.first.content"
    next: ->
      if @classifier.surface.tool::name is 'bubble'
        'markBubble'
      else
        'selectBubbleTool'

  selectBubbleTool:
    content: translate 'div', "tutorial.selectBubbleTool.content"
    instruction: translate 'div', "tutorial.selectBubbleTool.instruction"
    attachment: [0.5, 1, 'input[name="tool"][value="bubble"] + *', 0.5, 0]
    actionable: 'input[name="tool"][value="bubble"] + *'
    next: 'change input[name="tool"][value="bubble"]': 'markBubble'

  markBubble:
    content: translate 'div', "tutorial.markBubble.content"
    instruction: translate 'div', "tutorial.markBubble.instruction"
    next:
      'mouseup .marking-surface': 'adjustBubbleMarking'
      'touchend .marking-surface': 'adjustBubbleMarking'

  adjustBubbleMarking:
    content: translate 'div', "tutorial.adjustBubbleMarking.content"
    instruction: translate 'div', "tutorial.adjustBubbleMarking.instruction"
    next:
      'mouseup .marking-surface': 'selectClusterTool'
      'touchend .marking-surface': 'selectClusterTool'

  selectClusterTool:
    content: translate 'div', "tutorial.selectClusterTool.content"
    instruction: translate 'div', "tutorial.selectClusterTool.instruction"
    attachment: [0.5, 1, 'input[name="tool"][value="cluster"] + *', 0.5, 0]
    actionable: 'input[name="tool"][value="cluster"] + *'
    next: 'change input[name="tool"][value="cluster"]': 'markCluster'

  markCluster:
    content: translate 'div', "tutorial.markCluster.content"
    instruction: translate 'div', "tutorial.markCluster.instruction"
    next:
      'mouseup .marking-surface': 'selectEgoTool'
      'touchend .marking-surface': 'selectEgoTool'

  selectEgoTool:
    content: translate 'div', "tutorial.selectEgoTool.content"
    instruction: translate 'div', "tutorial.selectEgoTool.instruction"
    attachment: [0.5, 1, 'input[name="tool"][value="ego"] + *', 0.5, 0]
    actionable: 'input[name="tool"][value="ego"] + *'
    next: 'change input[name="tool"][value="ego"]': 'markEgo'

  markEgo:
    content: translate 'div', "tutorial.markEgo.content"
    instruction: translate 'div', "tutorial.markEgo.instruction"
    next:
      'mouseup .marking-surface': 'callOutTalk'
      'touchend .marking-surface': 'callOutTalk'

  callOutTalk:
    content: translate 'div', "tutorial.callOutTalk.content"
    attachment: [0, 0.5, 'a.discuss', 1, 0.5]
    next: 'callOutFavorite'

  callOutFavorite:
    content: translate 'div', "tutorial.callOutFavorite.content"
    attachment: [0, 0.5, 'button[name="favorite"]', 1, 0.5]
    next: 'callOutHelp'

  callOutHelp:
    content: translate 'div', "tutorial.callOutHelp.content"
    attachment: [0, 0.5, 'button[name="help"]', 1, 0.5]
    next: 'theEnd'

  theEnd:
    content: translate 'div', "tutorial.theEnd.content"

module.exports = tutorialSteps
