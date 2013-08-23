Navigation = require './controllers/navigation'
nav = new Navigation

Stack = require './controllers/stack'
stack = new Stack
  routes:
    '#/': require './controllers/home'
    '#/classify': require './controllers/classify'

nav.el.appendTo document.body
stack.el.appendTo document.body

window.app = module.exports = {nav, stack}
