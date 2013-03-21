$ ->
  flash 'Welcome to Mine Sweeper.'
  $(document).on 'click',    '.clear_adjacent a',   clearClicked
  $(document).on 'click',    '.mark_square a',      markClicked
  $(document).on 'click',    '.unmark_square a',    markClicked
  $(document).on 'click',    '#gameboard span', squareClicked
  $(document).on 'click',    '#new_game',       newGameClicked
  $(document).on 'click',    '#save_game',      saveGameClicked
  $(document).on 'click',    '#load_game',      loadGameClicked       
  startNewGame()

window.flash = (message) ->
  $message = $('<div class="message">' + message + '</div>')
  $('.flash').append $message
  $message.fadeOut 3000, () ->
    $message.remove()
    
squareClicked = (e) ->
  unless game.boom
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
  
clearClicked = (e) ->
  e.preventDefault()
  game.clear $(this).parents('span').data('id')
  drawBoard()
  return false

markClicked = (e) ->
  e.preventDefault()
  game.toggleMarking $(this).parents('span').data('id')
  drawBoard()
  return false
  
drawBoard = () ->
  $('#canvas').html('<div id="gameboard" />')
  
  game.validate()
  
  if game.boom
    $('#gameboard').addClass('boom')
    $('#canvas').append('<div id="boom">Aww Crap!</div>')
    
  if game.win
    $('#gameboard').addClass('boom')
    $('#canvas').append('<div id="boom">Yayyyyy!</div>')
  
  for i in [0..game.squares.length-1]
    square = game.squares[i]
    $element = $ '<span/>'
    $element.append '<div class="content" />'
      
    if square.adjacentMines > 0
      $element.addClass 'adjacentMines' + square.adjacentMines.toString()
      $element.find('.content').html square.adjacentMines.toString()
    else
      $element.addClass 'adjacentMines0'
      $element.find('.content').html '&nbsp;'
      
    $element.append $('#template .controls').clone()
      
    $element.data('id', i)
    
    if square.clicked
      $element.addClass('clicked')
    
    if square.isMine
      $element.addClass('mine')
      
    if square.marked
      $element.addClass('marked')
      
    if square.cleared
      $element.addClass('cleared')
      
    $('#gameboard').append($element)


window.winGame = () ->
  for square in game.squares
    if square.isMine
      square.marked = true
  drawBoard()
  
