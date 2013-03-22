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
  new_game = new MineSweeper.Game($(this).data('size'), $(this).data('mines'))
  
  startNewGame(new_game)
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
  flash("You haven't marked all the mines yet!") unless game.validate()
  return false

resetTimer = ->
  $("#seconds").text "00"
  $("#minutes").text "00"
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
  $('#canvas').html('<div id="gameboard" />')
  
  if game.boom
    $('#gameboard').addClass('boom')
    $('#canvas').append('<div id="boom">Aww Crap!</div>')
    stopTimer()
    
  if game.win
    $('#gameboard').addClass('boom')
    $('#canvas').append('<div id="boom">Yayyyyy!</div>')
    stopTimer()
    
  $('#mine_count').text game.minesRemaining()
  
  for i in [0..game.squares.length-1]
    square = game.squares[i]
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
      
    $('#gameboard').append($element)


window.winGame = () ->
  for square in game.squares
    if square.isMine
      square.marked = true
  drawBoard()
  
