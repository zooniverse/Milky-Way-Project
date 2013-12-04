{PI, random, sin, cos, min, max, abs} = Math
requestAnimationFrame = requestAnimationFrame || (fn) -> setTimeout fn, 60

class Throbber
  width: NaN
  height: NaN
  stars: 250
  rpm: 100 # I think?
  glow: 10

  className: 'throbber'

  constructor: (params = {}) ->
    @[property] = value for property, value of params

    @canvas ?= document.createElement 'canvas'
    @canvas.className = @className
    @canvas.width = @width if @width
    @canvas.height = @height if @height

    @ctx = @canvas.getContext '2d'

    @_stars = for i in [0...@stars]
      position: random()
      distance: abs random() - (random() * 0.5) # More toward the center
      offset: random()
      speed: random() * ((@rpm / 60) / 60)

  start: ->
    return if @playing
    @playing = true
    @loop()

  stop: ->
    @playing = false

  loop: =>
    @clear()
    @draw()
    @queue() if @playing

  clear: ->
    @ctx.clearRect 0, 0, @canvas.width, @canvas.height

  draw: ->
    {width, height} = @canvas
    {color, fontSize} = getComputedStyle @canvas
    fontSize = parseFloat(fontSize) / 2

    halfWidth = width / 2
    halfHeight = height / 2
    availableWidth = halfWidth - (fontSize + @glow)
    availableHeight = halfHeight - (fontSize + @glow)

    @ctx.fillStyle = color
    # @ctx.strokeStyle = color
    # @ctx.lineWidth = 2
    @ctx.shadowColor = color
    @ctx.shadowBlur = @glow

    for star in @_stars
      speedAddition = star.speed * (1 - star.distance)
      star.position = (star.position + speedAddition) % 1

      {position, distance, offset} = star

      x = distance * availableWidth * cos position * (PI * 2)
      y = distance * availableHeight * sin position * (PI * 2)
      r = (fontSize * offset) * ((y + availableHeight) / availableHeight)

      @ctx.globalAlpha = 1 - offset

      @ctx.beginPath()
      @ctx.arc halfWidth + x, halfHeight + y, r, 0, PI * 2
      @ctx.fill()

  queue: ->
    requestAnimationFrame @loop

module.exports = Throbber
