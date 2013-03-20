$ ->
  $(document).on 'click', '#new_game', (e) ->
    e.preventDefault()
    newGame()
  
  $(document).on 'click', '#gameboard span', (e) ->
    e.preventDefault()
    unless game.over
      game.click $(this).data('id')
      drawBoard()
      
  $(document).on 'click', '#save_game', (e) ->
    e.preventDefault()
    localStorage.setItem 'minesweeper.saved_game', JSON.stringify(game.toJSON())
    
  $(document).on 'click', '#load_game', (e) ->
    e.preventDefault()
    newGame MineSweeper.Game.fromJSON(JSON.parse(localStorage.getItem('minesweeper.saved_game')))
          
  newGame()

newGame = (new_game) ->
  new_game ?= new MineSweeper.Game()
  window.game = new_game
  drawBoard()
  
drawBoard = () ->
  $('#canvas').html('<div id="gameboard" />')
  
  if game.over
    $('#gameboard').addClass('boom')
    $('#canvas').append('<div id="boom">Aww Crap!</div>')
  
  
  for i in [0..game.squares.length-1]
    square = game.squares[i]
    $element = $ '<span>&nbsp;</span>'
    $element.data('id', i)
    
    if square.clicked
      $element.addClass('clicked')
    
    if square.isMine
      $element.addClass('mine')
      
      
    # $('#gameboard').replaceWith($($('#gameboard span').toArray().shuffle().join('')))
      
    $('#gameboard').append($element)

