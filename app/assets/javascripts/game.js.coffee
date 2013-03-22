
class Game
  constructor: (@size, @mines) ->
    @size ?= 8
    @mines ?= 10
    @boom = false
    @squares = (new Square(true) for num in [1..@mines])
    for num in [@mines..(@size*@size)-1]
      @squares.push(new Square(false))
    @shuffle()
    @setAdjacentMinesCount()
    
  click: (i) ->
    @squares[i].clicked = true
    
    if @squares[i].isMine
      @boom = true
      
  shuffle: () ->
    i = @squares.length - 1

    while i
      j = Math.floor(Math.random() * i)
      x = @squares[i]
      @squares[i] = @squares[j]
      @squares[j] = x
      i--

    return null
  
  minesRemaining: () ->
    mines = @mines - @getMarkedSquares().length
    if mines < 10
      return "0" + mines.toString()
    else
      return mines
  
  setAdjacentMinesCount: () ->
    for i in [0..@squares.length-1]
      @squares[i].adjacentMines = @getAdjacentMines(i)
    
  getPositionById: (i) ->
    [i % @size, Math.floor(i/@size)]
    
  getIdByPosition: (x, y) ->
    if x > -1 and y > -1 and x < @size and y < @size
      y * @size + x
    else
      null
  
  getMarkedSquares: () ->
    @squares.filter((x) -> return true if x.marked)
    
  validate: () ->
    if @getMarkedSquares().length == @mines
      for square in @getMarkedSquares()
        if !square.isMine
          @boom = true
      @win = true
      return true
    return false
    
    
      
  clear: (baseId) ->
    @click(baseId)
    @squares[baseId].cleared = true
    for id in @getAdjacentSquares(baseId)
      square = @squares[id]
      unless square.clicked or square.marked
        @click(id)
        if square.adjacentMines == 0
          @clear(id)
      
  getAdjacentSquares: (baseId) ->
    position = @getPositionById(baseId)
    squares = []
    for x in [position[0]-1..position[0]+1]
      for y in [position[1]-1..position[1]+1]
        id = @getIdByPosition(x,y)
        if id != null and id != baseId
          squares.push id
    squares.sort()
    
  getAdjacentMines: (baseId) ->
    mines = 0
    for id in @getAdjacentSquares(baseId)
      mines++ if @squares[id].isMine
    return mines
    
  toJSON: () ->
    data =
      size: @size
      mines: @mines
      squares: ({
        clicked: square.clicked
        mine: square.isMine
        adjacentMines: square.adjacentMines
        marked: square.marked
        cleared: square.cleared
      } for square in @squares)

  toggleMarking: (id) ->
    @squares[id].marked = !@squares[id].marked

Game.fromJSON = (data) ->
  game = new Game()
  game.size = data.size
  game.mines = data.mines
  game.squares = []
  for square_data in data.squares
    game.squares.push(
      new Square(square_data.mine, square_data.clicked, square_data.adjacentMines, square_data.marked, square_data.cleared)
    )
  return game
      

class Square
  constructor: (@isMine, @clicked, @adjacentMines, @marked, @cleared) ->
    @clicked ?= false  

window.MineSweeper =
  Game: Game


