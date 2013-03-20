$ ->
  flash 'Welcome to Mine Sweeper.'
  $(document).on 'click', '#gameboard span', squareClicked
  $(document).on 'click', '#new_game',       newGameClicked
  $(document).on 'click', '#save_game',      saveGameClicked
  $(document).on 'click', '#load_game',      loadGameClicked          
  startNewGame()

window.flash = (message) ->
  $message = $('<div class="message">' + message + '</div>')
  $('.flash').append $message
  $message.fadeOut 3000, () ->
    $message.remove()
    
squareClicked = (e) ->
  e.preventDefault()
  unless game.over
    game.click $(this).data('id')
    drawBoard()

newGameClicked = (e) ->
  e.preventDefault()
  startNewGame()
  flash 'Mayest thou not be scorched.'

saveGameClicked =  (e) ->
  e.preventDefault()
  localStorage.setItem 'minesweeper.saved_game', JSON.stringify(game.toJSON())
  flash 'Salvation is nigh.'

loadGameClicked =  (e) ->
  e.preventDefault()
  startNewGame MineSweeper.Game.fromJSON(JSON.parse(localStorage.getItem('minesweeper.saved_game')))
  flash 'You have been brought back.'

startNewGame = (new_game) ->
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
      
    $('#gameboard').append($element)

