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
  
  describe "#toggleMarking", ->
    it "should mark an unmarked square.", ->
      expect(game.squares[1].marked).toBeFalsy()
      game.toggleMarking(1)
      expect(game.squares[1].marked).toBeTruthy()

    it "should unmark a marked square.", ->
      expect(game.squares[1].marked).toBeFalsy()
      game.toggleMarking(1)
      expect(game.squares[1].marked).toBeTruthy()
      game.toggleMarking(1)
      expect(game.squares[1].marked).toBeFalsy()
      
  describe "#clear", ->
    it "should mark the square cleared", ->
      clear_square = game.squares.filter((a) -> return true if a.adjacentMines==0)[0]
      game.clear game.squares.indexOf(clear_square)
      expect(clear_square.cleared).toBeTruthy()
      
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
        expect(game.boom).toBeFalsy()
    
    
    describe "when it is a mine", ->
      the_square = null
      beforeEach ->
        the_square = aMine()
        game.click(the_square)
      
      it "should set the 'boom' status", ->
        expect(game.boom).toBeTruthy()
        

    example_json =
      size: 2
      mines: 1
      squares: [
        clicked: true
        mine: false
        adjacentMines: 1
        marked: false
        cleared: true
      ,
        clicked: false
        mine: true
        adjacentMines: 0
        marked: false
        cleared: false
      ,
        clicked: false
        mine: false
        adjacentMines: 1
        marked: false
        cleared: false
      ,
        clicked: false
        mine: false
        adjacentMines: 1
        marked: false
        cleared: false
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
        
    describe "Finding Adjacent Mines", ->
      game = null
      beforeEach ->
        game = new MineSweeper.Game()
      describe "getPositionById()", ->
        it "should return x and y for the square", ->
          expect(game.getPositionById(0)).toEqual([0, 0])
          expect(game.getPositionById(1)).toEqual([1, 0])
          expect(game.getPositionById(7)).toEqual([7, 0])
          expect(game.getPositionById(8)).toEqual([0, 1])
          expect(game.getPositionById(63)).toEqual([7, 7])
      
      describe "getIdByPosition()", ->
        it "it should return the id for the coordinates", ->
          expect(game.getIdByPosition(0, 0)).toEqual(0)
          expect(game.getIdByPosition(0, 2)).toEqual(16)
          expect(game.getIdByPosition(1, 2)).toEqual(17)
          expect(game.getIdByPosition(7, 7)).toEqual(63)
        describe "when out of bounds", ->
          it "should return null", ->
            expect(game.getIdByPosition(-1, 0)).toEqual(null)
            expect(game.getIdByPosition(8, 2)).toEqual(null)
            expect(game.getIdByPosition(1, 8)).toEqual(null)
            expect(game.getIdByPosition(7, -7)).toEqual(null)
      
      describe "getAdjacentSquares()", ->
        it "should return all existing squares that are adjacent.", ->
          expect(game.getAdjacentSquares(0)).toEqual([1, 8, 9])
          
      describe "getAdjacentMines()", ->
        it "should return the number of mines in adjacent squares", ->
          #  Fudge some stuff
          game.squares[1].isMine = true
          game.squares[8].isMine = true
          game.squares[9].isMine = false
          expect(game.getAdjacentMines(0)).toEqual(2)
          
      
