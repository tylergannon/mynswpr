$ ->
  flash 'Welcome to Mine Sweeper.'
  $(document).on 'click',    '.clear_adjacent a',   clearClicked
  $(document).on 'click',    '.mark_square a',      markClicked
  $(document).on 'click',    '.unmark_square a',    markClicked
  $(document).on 'click',    '#gameboard span', squareClicked
  $(document).on 'click',    'a.new_game',      newGameClicked
  $(document).on 'click',    '#save_game',      saveGameClicked
  $(document).on 'click',    '#load_game',      loadGameClicked       
  $(document).on 'click',    '#validate',       validateClicked       
  startNewGame()
  

losers = [
  'http://cdn.memegenerator.net/instances/400x/36522451.jpg',
  'http://cdn.memegenerator.net/instances/400x/36522530.jpg',
  'http://cdn.memegenerator.net/instances/400x/36522861.jpg',
  'http://cdn.memegenerator.net/instances/400x/36522965.jpg',
  'http://cdn.memegenerator.net/instances/400x/36523338.jpg',
  'http://cdn.memegenerator.net/instances/400x/36523457.jpg'
  ]

    
squareClicked = (e) ->
  unless game.boom
    game.click $(this).data('id')
    drawBoard()

newGameClicked = (e) ->
  e.preventDefault()
  new_game = new MineSweeper.Game($(this).data('size'), $(this).data('mines'))
  startNewGame(new_game)
  flash $(this).data('message'), $(this).css('background-image')

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
  resetTimer()
  
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
  
validateClicked = (e) ->
  e.preventDefault()
  if game.validate()
    drawBoard()
  else
    flash("You haven't marked all the mines yet!")
  return false

resetTimer = ->
  $("#seconds").text "00"
  $("#minutes").text "00"
  stopTimer()
  window.timer = setInterval "showTime()", 1000

stopTimer = ->
  clearInterval window.timer
  

window.showTime = ->
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

drawBoard = () ->
  view = new MineSweeper.View(window.game)
  $('#canvas').html view.drawBoard()

window.winGame = () ->
  for square in game.squares
    if square.isMine
      square.marked = true
  drawBoard()
  
