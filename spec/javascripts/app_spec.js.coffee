
# use require to load any .js file available to the asset pipeline


describe "Application", ->
  beforeEach ->
    loadFixtures 'example_fixture.html' # located at 'spec/javascripts/fixtures/example_fixture.html.haml'
    $('#new_game').click()
  
  describe "When 'new game' is clicked", ->
    it "should add span elements to the game board", ->
      expect($('#gameboard span').length).toEqual(64)
    it "should give each square an id", ->
      for i in [0..63]
        expect($($('#gameboard').children()[i]).data('id')).toEqual(i)
    
    it "should have 10 mines by default", ->
      expect( $('#gameboard span.mine').length ).toEqual(10)
        
        
  describe "When a square is clicked", ->
    aMine = () ->
      for i in [0..game.squares.length]
        return i if game.squares[i].isMine
    aNonMine = () ->
      for i in [0..game.squares.length]
        return i unless game.squares[i].isMine
    
    describe "and the square has no mine", ->
      it "should add 'clicked' class to the square", ->
        selector = '#gameboard span:nth-child(' + (aNonMine()+1).toString() + ')'
        $(selector).click()
        expect($(selector).hasClass('clicked')).toBeTruthy()
        
    describe "and the square has a mine", ->
      selector = null
      
      beforeEach ->
        selector = '#gameboard span:nth-child(' + (aMine()+1).toString() + ')'
        $(selector).click()
        
      it "should add 'clicked' class to the square", ->
        expect($(selector).hasClass('clicked')).toBeTruthy()
        
      it "should add 'boom' class to gameboard", ->
        expect($('#gameboard').hasClass('boom')).toBeTruthy()
        
      it "should add 'mine' class to mines", ->
        expect($(selector).hasClass('mine')).toBeTruthy()
        
  describe "Saving / Loading", ->
    beforeEach ->
      $('#gameboard span').not('.mine').click()
      
    it "should have a clicked square", ->
      expect($('#gameboard span.clicked').length).toEqual(1)
      
    describe "After saving and starting a new game", ->
      beforeEach ->
        $('#save_game').click()
        $('#new_game').click()
        
      it "should be a new game now", ->
        expect($('#gameboard span.clicked').length).toEqual(0)
        
      describe "and then reloading the saved game", ->
        beforeEach ->
          $('#load_game').click()
        it "should now have a clicked square", ->
          expect($('#gameboard span.clicked').length).toEqual(1)
      
      
