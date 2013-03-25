class View
  constructor: (@game) ->
    @board = $('<div id="gameboard" />')
    
  drawBoard: () ->
  # $('#canvas').html('<div id="gameboard" />')
  
    if @game.boom
      @board.addClass('boom')
      flash('Awwwwww Crap!')
      flash('<img src="'  + losers[Math.floor(Math.random() * losers.length)] + '"></img>', null, 8000)
      stopTimer()
    
    if @game.win
    
      @board.addClass('boom')
      flash('Yayyyyyy!!!')
      # $('#canvas').append('<div id="boom">Yayyyyy!</div>')
      stopTimer()

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

window.MineSweeper.View = View
