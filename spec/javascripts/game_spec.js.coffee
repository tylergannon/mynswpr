# use require to load any .js file available to the asset pipeline


describe "Game", ->
  game = null
  
  beforeEach ->
    game = new MineSweeper.Game()
        
  it "it should have a default size of 8", ->
    expect(game.size).toEqual(8)
    
  it "should have 10 mines by default", ->
    expect(game.mines).toEqual(10)
    
  it "should have 'size-squared' squares", ->
    expect(game.squares.length).toEqual(game.size * game.size)
    
  it "should not be game over just yet", ->
    expect(game.boom).toBeFalsy()
    
  it "should have as many actual mines as specified on the game attributes.", ->
    mines = 0
    for square in game.squares
      if square.isMine
        mines++
    
    expect(mines).toEqual(game.mines)
    
    
  #  Cheap... just make sure that in the first ten there are mines and non-mines.
  it "should shuffle the squares", ->
    foundANonExploder = false
    foundAMine = false
    
    for i in [0..9]
      foundANonExploder = true unless game.squares[i].isMine
      foundAMine = true if game.squares[i].isMine
    
    expect(foundANonExploder).toBeTruthy 'There should be at least one non-mine there.'
    
  it "should set all the squares to be not clicked", ->
    for square in game.squares
      expect(square.clicked).toBeFalsy()
      
  describe "#click", ->
    aMine = () ->
      for i in [0..game.squares.length]
        return i if game.squares[i].isMine
    aNonMine = () ->
      for i in [0..game.squares.length]
        return i unless game.squares[i].isMine
    
    describe "when it is not mine", ->
      the_square = null
      beforeEach ->
        the_square = aNonMine()
        game.click(the_square)
        
      it "should change the status of the square to clicked", ->
        expect(game.squares[the_square].clicked).toBeTruthy()

      it "should not be game over just yet", ->
        expect(game.over).toBeFalsy()
    
    
    describe "when it is a mine", ->
      the_square = null
      beforeEach ->
        the_square = aMine()
        game.click(the_square)
      
      it "should set the 'boom' status", ->
        expect(game.over).toBeTruthy()
        

    example_json =
      size: 2
      mines: 1
      squares: [
        clicked: true
        mine: false
      ,
        clicked: false
        mine: true
      ,
        clicked: false
        mine: false
      ,
        clicked: false
        mine: false
        ]

    describe "fromJSON()", ->
      new_game = null
      beforeEach ->
        new_game = MineSweeper.Game.fromJSON(example_json)
      
      it "should have size = 2", ->
        expect(new_game.size).toEqual(2)
        
      it "should have one mine", ->
        expect(new_game.mines).toEqual(1)
        
      it "should have four squares", ->
        expect(new_game.squares.length).toEqual(4)
        
      it "should have a mine in the second square", ->
        expect(new_game.squares[1].isMine).toBeTruthy()
        
      it "should have the first square clicked", ->
        expect(new_game.squares[0].clicked).toBeTruthy()
        
      it "should have the fourth square not-clicked", ->
        expect(new_game.squares[3].clicked).toBeFalsy()
        
    describe "toJSON()", ->
      it "should render a JSON array exactly the same as that which loaded the game.", ->
        game = MineSweeper.Game.fromJSON(example_json)
        expect(game.toJSON()).toEqual(example_json)
        
