
class Game
  constructor: () ->
    @size = 8
    @mines = 10
    @over = false
    @squares = (new Square(true) for num in [1..@mines])
    for num in [@mines..(@size*@size)-1]
      @squares.push(new Square(false))
    @shuffle()
    
  click: (i) ->
    @squares[i].clicked = true
    
    if @squares[i].isMine
      @over = true
      
  shuffle: () ->
    i = @squares.length - 1

    while i
      j = Math.floor(Math.random() * i)
      x = @squares[i]
      @squares[i] = @squares[j]
      @squares[j] = x
      i--

    return null
    
  toJSON: () ->
    data =
      size: @size
      mines: @mines
      squares: ({clicked: square.clicked, mine: square.isMine} for square in @squares)

Game.fromJSON = (data) ->
  game = new Game()
  game.size = data.size
  game.mines = data.mines
  game.squares = []
  for square_data in data.squares
    game.squares.push(new Square(square_data.mine, square_data.clicked))
  return game
      

class Square
  constructor: (@isMine, @clicked) ->
    @clicked ?= false


window.MineSweeper =
  Game: Game


