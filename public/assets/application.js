(function() {
  var Game, Square;

  Game = (function() {
    function Game(size, mines) {
      var num, _i, _ref, _ref1, _ref2, _ref3;

      this.size = size;
      this.mines = mines;
      if ((_ref = this.size) == null) {
        this.size = 8;
      }
      if ((_ref1 = this.mines) == null) {
        this.mines = 10;
      }
      this.boom = false;
      this.squares = (function() {
        var _i, _ref2, _results;

        _results = [];
        for (num = _i = 1, _ref2 = this.mines; 1 <= _ref2 ? _i <= _ref2 : _i >= _ref2; num = 1 <= _ref2 ? ++_i : --_i) {
          _results.push(new Square(true));
        }
        return _results;
      }).call(this);
      for (num = _i = _ref2 = this.mines, _ref3 = (this.size * this.size) - 1; _ref2 <= _ref3 ? _i <= _ref3 : _i >= _ref3; num = _ref2 <= _ref3 ? ++_i : --_i) {
        this.squares.push(new Square(false));
      }
      this.shuffle();
      this.setAdjacentMinesCount();
    }

    Game.prototype.click = function(i) {
      this.squares[i].clicked = true;
      if (this.squares[i].isMine) {
        return this.boom = true;
      }
    };

    Game.prototype.shuffle = function() {
      var i, j, x;

      i = this.squares.length - 1;
      while (i) {
        j = Math.floor(Math.random() * i);
        x = this.squares[i];
        this.squares[i] = this.squares[j];
        this.squares[j] = x;
        i--;
      }
      return null;
    };

    Game.prototype.minesRemaining = function() {
      var mines;

      mines = this.mines - this.getMarkedSquares().length;
      if (mines < 10) {
        return "0" + mines.toString();
      } else {
        return mines;
      }
    };

    Game.prototype.setAdjacentMinesCount = function() {
      var i, _i, _ref, _results;

      _results = [];
      for (i = _i = 0, _ref = this.squares.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        _results.push(this.squares[i].adjacentMines = this.getAdjacentMines(i));
      }
      return _results;
    };

    Game.prototype.getPositionById = function(i) {
      return [i % this.size, Math.floor(i / this.size)];
    };

    Game.prototype.getIdByPosition = function(x, y) {
      if (x > -1 && y > -1 && x < this.size && y < this.size) {
        return y * this.size + x;
      } else {
        return null;
      }
    };

    Game.prototype.getMarkedSquares = function() {
      return this.squares.filter(function(x) {
        if (x.marked) {
          return true;
        }
      });
    };

    Game.prototype.validate = function() {
      var square, _i, _len, _ref;

      if (this.getMarkedSquares().length === this.mines) {
        _ref = this.getMarkedSquares();
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          square = _ref[_i];
          if (!square.isMine) {
            this.boom = true;
          }
        }
        this.win = true;
        return true;
      }
      return false;
    };

    Game.prototype.clear = function(baseId) {
      var id, square, _i, _len, _ref, _results;

      this.click(baseId);
      this.squares[baseId].cleared = true;
      _ref = this.getAdjacentSquares(baseId);
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        id = _ref[_i];
        square = this.squares[id];
        if (!(square.clicked || square.marked)) {
          this.click(id);
          if (square.adjacentMines === 0) {
            _results.push(this.clear(id));
          } else {
            _results.push(void 0);
          }
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    Game.prototype.getAdjacentSquares = function(baseId) {
      var id, position, squares, x, y, _i, _j, _ref, _ref1, _ref2, _ref3;

      position = this.getPositionById(baseId);
      squares = [];
      for (x = _i = _ref = position[0] - 1, _ref1 = position[0] + 1; _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; x = _ref <= _ref1 ? ++_i : --_i) {
        for (y = _j = _ref2 = position[1] - 1, _ref3 = position[1] + 1; _ref2 <= _ref3 ? _j <= _ref3 : _j >= _ref3; y = _ref2 <= _ref3 ? ++_j : --_j) {
          id = this.getIdByPosition(x, y);
          if (id !== null && id !== baseId) {
            squares.push(id);
          }
        }
      }
      return squares.sort();
    };

    Game.prototype.getAdjacentMines = function(baseId) {
      var id, mines, _i, _len, _ref;

      mines = 0;
      _ref = this.getAdjacentSquares(baseId);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        id = _ref[_i];
        if (this.squares[id].isMine) {
          mines++;
        }
      }
      return mines;
    };

    Game.prototype.toJSON = function() {
      var data, square;

      return data = {
        size: this.size,
        mines: this.mines,
        squares: (function() {
          var _i, _len, _ref, _results;

          _ref = this.squares;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            square = _ref[_i];
            _results.push({
              clicked: square.clicked,
              mine: square.isMine,
              adjacentMines: square.adjacentMines,
              marked: square.marked,
              cleared: square.cleared
            });
          }
          return _results;
        }).call(this)
      };
    };

    Game.prototype.toggleMarking = function(id) {
      return this.squares[id].marked = !this.squares[id].marked;
    };

    return Game;

  })();

  Game.fromJSON = function(data) {
    var game, square_data, _i, _len, _ref;

    game = new Game();
    game.size = data.size;
    game.mines = data.mines;
    game.squares = [];
    _ref = data.squares;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      square_data = _ref[_i];
      game.squares.push(new Square(square_data.mine, square_data.clicked, square_data.adjacentMines, square_data.marked, square_data.cleared));
    }
    return game;
  };

  Square = (function() {
    function Square(isMine, clicked, adjacentMines, marked, cleared) {
      var _ref;

      this.isMine = isMine;
      this.clicked = clicked;
      this.adjacentMines = adjacentMines;
      this.marked = marked;
      this.cleared = cleared;
      if ((_ref = this.clicked) == null) {
        this.clicked = false;
      }
    }

    return Square;

  })();

  window.MineSweeper = {
    Game: Game
  };

}).call(this);
(function() {
  var clearClicked, drawBoard, loadGameClicked, markClicked, newGameClicked, resetTimer, saveGameClicked, squareClicked, startNewGame, stopTimer, validateClicked;

  $(function() {
    flash('Welcome to Mine Sweeper.');
    $(document).on('click', '.clear_adjacent a', clearClicked);
    $(document).on('click', '.mark_square a', markClicked);
    $(document).on('click', '.unmark_square a', markClicked);
    $(document).on('click', '#gameboard span', squareClicked);
    $(document).on('click', 'a.new_game', newGameClicked);
    $(document).on('click', '#save_game', saveGameClicked);
    $(document).on('click', '#load_game', loadGameClicked);
    $(document).on('click', '#validate', validateClicked);
    return startNewGame();
  });

  window.flash = function(message) {
    var $message;

    $message = $('<div class="message">' + message + '</div>');
    $('.flash').append($message);
    return $message.fadeOut(3000, function() {
      return $message.remove();
    });
  };

  squareClicked = function(e) {
    if (!game.boom) {
      game.click($(this).data('id'));
      return drawBoard();
    }
  };

  newGameClicked = function(e) {
    var new_game;

    e.preventDefault();
    new_game = new MineSweeper.Game($(this).data('size'), $(this).data('mines'));
    startNewGame(new_game);
    return flash('Mayest thou not be scorched.');
  };

  saveGameClicked = function(e) {
    e.preventDefault();
    localStorage.setItem('minesweeper.saved_game', JSON.stringify(game.toJSON()));
    return flash('Salvation is nigh.');
  };

  loadGameClicked = function(e) {
    e.preventDefault();
    startNewGame(MineSweeper.Game.fromJSON(JSON.parse(localStorage.getItem('minesweeper.saved_game'))));
    return flash('You have been brought back.');
  };

  startNewGame = function(new_game) {
    if (new_game == null) {
      new_game = new MineSweeper.Game();
    }
    window.game = new_game;
    drawBoard();
    return resetTimer();
  };

  clearClicked = function(e) {
    e.preventDefault();
    game.clear($(this).parents('span').data('id'));
    drawBoard();
    return false;
  };

  markClicked = function(e) {
    e.preventDefault();
    game.toggleMarking($(this).parents('span').data('id'));
    drawBoard();
    return false;
  };

  validateClicked = function(e) {
    e.preventDefault();
    if (game.validate()) {
      drawBoard();
    } else {
      flash("You haven't marked all the mines yet!");
    }
    return false;
  };

  resetTimer = function() {
    $("#seconds").text("00");
    $("#minutes").text("00");
    return window.timer = setInterval("showTime()", 1000);
  };

  stopTimer = function() {
    return clearInterval(window.timer);
  };

  window.showTime = function() {
    var m, s;

    s = parseInt($("#seconds").text());
    m = parseInt($("#minutes").text());
    s++;
    if (s > 59) {
      s = 0;
      m++;
    }
    if (s < 10) {
      s = "0" + s.toString();
    }
    if (m < 10) {
      m = "0" + m.toString();
    }
    $("#seconds").text(s);
    return $("#minutes").text(m);
  };

  drawBoard = function() {
    var $element, i, square, _i, _ref, _results;

    $('#canvas').html('<div id="gameboard" />');
    if (game.boom) {
      $('#gameboard').addClass('boom');
      flash('Awwwwww Crap!');
      stopTimer();
    }
    if (game.win) {
      $('#gameboard').addClass('boom');
      flash('Yayyyyyy!!!');
      stopTimer();
    }
    $('#gameboard').addClass('size' + game.size.toString());
    $('#mine_count').text(game.minesRemaining());
    _results = [];
    for (i = _i = 0, _ref = game.squares.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
      square = game.squares[i];
      $element = $('<span/>');
      $element.append($('#template .controls').clone());
      $element.append('<div class="content" />');
      if (square.adjacentMines > 0) {
        $element.addClass('adjacentMines' + square.adjacentMines.toString());
        $element.find('.content').html(square.adjacentMines.toString());
      } else {
        $element.addClass('adjacentMines0');
        $element.find('.content').html('&nbsp;');
      }
      $element.data('id', i);
      if (square.clicked) {
        $element.addClass('clicked');
      }
      if (square.isMine) {
        $element.addClass('mine');
      }
      if (square.marked) {
        $element.addClass('marked');
      }
      if (square.cleared) {
        $element.addClass('cleared');
      }
      _results.push($('#gameboard').append($element));
    }
    return _results;
  };

  window.winGame = function() {
    var square, _i, _len, _ref;

    _ref = game.squares;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      square = _ref[_i];
      if (square.isMine) {
        square.marked = true;
      }
    }
    return drawBoard();
  };

}).call(this);
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//


;
