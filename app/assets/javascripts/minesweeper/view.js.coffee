class View
  constructor: (@game) ->
    @board = $('<div id="gameboard" />')
    
    
  losers:
    [
      'http://cdn.memegenerator.net/instances/400x/36522451.jpg',
      'http://cdn.memegenerator.net/instances/400x/36522530.jpg',
      'http://cdn.memegenerator.net/instances/400x/36522861.jpg',
      'http://cdn.memegenerator.net/instances/400x/36522965.jpg',
      'http://cdn.memegenerator.net/instances/400x/36523338.jpg',
      'http://cdn.memegenerator.net/instances/400x/36523457.jpg'
      ]
    
  drawBoard: () ->
  # $('#canvas').html('<div id="gameboard" />')
  
    if @game.boom
      @board.addClass('boom')
      flash('Awwwwww Crap!')
      flash('<img src="'  + @losers[Math.floor(Math.random() * @losers.length)] + '"></img>', null, 8000)
      @stopTimer()
    
    if @game.win
      @board.addClass('boom')
      flash('Yayyyyyy!!!')
      @stopTimer()

    @board.addClass('size' + @game.size.toString())
    
    $('#mine_count').text @game.minesRemaining()
  
    for i in [0..@game.squares.length-1]
      square = @game.squares[i]
      $element = $ '<span/>'

      $element.append $('#template .controls').clone()

      $element.append '<div class="content" />'
      
      if square.adjacentMines > 0
        $element.addClass 'adjacentMines' + square.adjacentMines.toString()
        $element.find('.content').html square.adjacentMines.toString()
      else
        $element.addClass 'adjacentMines0'
        $element.find('.content').html '&nbsp;'
      
      
      $element.data('id', i)
    
      if square.clicked
        $element.addClass('clicked')
    
      if square.isMine
        $element.addClass('mine')
      
      if square.marked
        $element.addClass('marked')
      
      if square.cleared
        $element.addClass('cleared')
      
      @board.append($element)

  resetTimer: ->
    $("#seconds").text "00"
    $("#minutes").text "00"
    @stopTimer()
    window.timer = setInterval @showTime, 1000

  stopTimer: ->
    clearInterval window.timer

  showTime: ->
    s = parseInt($("#seconds").text())
    m = parseInt($("#minutes").text())
    s++
    if s > 59
      s = 0
      m++
    if s < 10
      s = "0" + s.toString()
    if m < 10
      m = "0" + m.toString()
    $("#seconds").text s
    $("#minutes").text m


window.MineSweeper.View = View
