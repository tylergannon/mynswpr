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

window.flash = (message, image, time) ->
  $message = $('<div class="message">' + message + '</div>')
  if image?
    $message.css('background-image', image)
    $message.css('background-size', '90px')
    $message.css('background-repeat', 'no-repeat')
    $message.css('text-indent', '90px')
  $('.flash').append $message
  $message.fadeOut (time || 3000), () ->
    $message.remove()
    
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
  $('#canvas').html('<div id="gameboard" />')
  
  if game.boom
    $('#gameboard').addClass('boom')
    flash('Awwwwww Crap!')
    flash('<img src="'  + losers[Math.floor(Math.random() * losers.length)] + '"></img>', null, 8000)
    stopTimer()
    
  if game.win
    $('#gameboard').addClass('boom')
    flash('Yayyyyyy!!!')
    # $('#canvas').append('<div id="boom">Yayyyyy!</div>')
    stopTimer()

  $('#gameboard').addClass('size' + game.size.toString())
    
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
  
