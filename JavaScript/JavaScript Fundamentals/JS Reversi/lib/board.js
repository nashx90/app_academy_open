let Piece = require("./piece");

/**
 * Returns a 2D array (8 by 8) with two black pieces at [3, 4] and [4, 3]
 * and two white pieces at [3, 3] and [4, 4]
 */
function _makeGrid () {
  let grid = new Array(8);
  for (let i = 0; i < grid.length; i++) {
    grid[i] = new Array(8);
  }
  grid[3][4] = new Piece("black");
  grid[4][3] = new Piece("black");
  grid[4][4] = new Piece("white");
  grid[3][3] = new Piece("white");
  return grid;
}

/**
 * Constructs a Board with a starting grid set up.
 */
function Board () {
  this.grid = _makeGrid();
}

Board.DIRS = [
  [ 0,  1], [ 1,  1], [ 1,  0],
  [ 1, -1], [ 0, -1], [-1, -1],
  [-1,  0], [-1,  1]
];

/**
 * Returns the piece at a given [x, y] position,
 * throwing an Error if the position is invalid.
 */
Board.prototype.getPiece = function (pos) {
  return this.grid[pos[0]][pos[1]];
};

Board.prototype.myPieces = function(myColor) {
  let grid = this.grid;
  let myPieces = [];
  for (let i = 0; i < grid.length; i++) {
    let row = grid[i];
    for (let j = 0; j < row.length; j++) {
      let piece = row[j];
      if (piece == undefined) {
        continue;
      } else if (piece.color == myColor) {
        myPieces.push([i, j])
      }
    }
  }
  return myPieces;
}

/**
 * Checks if there are any valid moves for the given color.
 */
Board.prototype.hasMove = function (myColor) {
  return (this.validMoves(myColor).length > 0 ? true : false);
};

/**
 * Checks if the piece at a given position
 * matches a given color.
 */
Board.prototype.isMine = function (pos, color) {
  if (this.isValidPos(pos)) {
    let piece = this.grid[pos[0]][pos[1]];
    if (piece == undefined) {
      return false;
    }
    return (piece.color == color ? true : false );
  }
};

/**
 * Checks if a given position has a piece on it.
 */
Board.prototype.isOccupied = function (pos) {
  if (this.isValidPos(pos)) {
    return (this.grid[pos[0]][pos[1]] == undefined ? false : true );
  }
};

/**
 * Checks if both the white player and
 * the black player are out of moves.
 */
Board.prototype.isOver = function () {
  if (this.hasMove("black") || this.hasMove("white")) {
    return false;
  } else {
    return true;
  }
};

/**
 * Checks if a given position is on the Board.
 */
Board.prototype.isValidPos = function (pos) {
  if (pos[0] > 7 || pos[1] > 7 || pos[0] < 0 || pos[1] < 0) {
    return false;
  }
  return true;
};

/**
 * Recursively follows a direction away from a starting position, adding each
 * piece of the opposite color until hitting another piece of the current color.
 * It then returns an array of all pieces between the starting position and
 * ending position.
 *
 * Returns null if it reaches the end of the board before finding another piece
 * of the same color.
 *
 * Returns null if it hits an empty position.
 *
 * Returns null if no pieces of the opposite color are found.
 */
function _positionsToFlip (board, pos, myColor, dir, piecesToFlip) {
  if (!piecesToFlip) {
    piecesToFlip = [];
  } else {
    piecesToFlip.push(pos);
  }
  let expPos = [(dir[0] + pos[0]), (dir[1] + pos[1])];
  if (!board.isValidPos(expPos)) {
    return null;
  } else if (!board.isOccupied(expPos)) {
    return null;
  } else if (board.isMine(expPos, myColor)) {
    return piecesToFlip.length == 0 ? null : piecesToFlip;
  } else {
    return _positionsToFlip(board, expPos, myColor, dir, piecesToFlip);
  }
}

/**
 * Adds a new piece of the given color to the given position, flipping the
 * color of any pieces that are eligible for flipping.
 *
 * Throws an error if the position represents an invalid move.
 */
Board.prototype.placePiece = function (pos, color) {
  if (!this.validMove(pos, color)) {
    throw new Error("Invalid move!");
  }
  let board = this;
  let positionsToFlip = [];
  for (let i = 0; i < Board.DIRS.length; i++) {
    positionsToFlip = positionsToFlip.concat(_positionsToFlip(this, pos, color, Board.DIRS[i]) || [] );
  }
  positionsToFlip.forEach(flipPos => {
    board.getPiece(flipPos).flip();
  });
  board.grid[pos[0]][pos[1]] = new Piece(color);
};

/**
 * Prints a string representation of the Board to the console.
 */
Board.prototype.print = function () {
  console.log("  0 1 2 3 4 5 6 7")
  for (let r = 0; r < this.grid.length; r++) {
    const row = this.grid[r];
    printRow = `${r}`
    for (let i = 0; i < row.length; i++) {
      const spot = row[i];
      if (spot == undefined) {
        printRow += " ·";
      } else {
        printRow += (" " + spot.toString());
      }
    }
    console.log(printRow);
  }
};

/**
 * Checks that a position is not already occupied and that the color
 * taking the position will result in some pieces of the opposite
 * color being flipped.
 */
Board.prototype.validMove = function (pos, color) {
  return (this.validMoves(color).filter(el => el[0] == pos[0] && el[1] == pos[1]).length > 0 ? true : false);
};

/**
 * Produces an array of all valid positions on
 * the Board for a given color.
 */
Board.prototype.validMoves = function (myColor) {
  let board = this;
  let validMoves = [];
  function expand(pos, dir) {
    let expPos = [(dir[0] + pos[0]), (dir[1] + pos[1])];
    if (!board.isValidPos(expPos)) {
      return false;
    }
    let expPiece = board.grid[expPos[0]][expPos[1]];
    if (expPiece == undefined) {
      return expPos;
    } else if (expPiece.color != myColor) {
      expand(expPos, dir);
    }
  }

  if (board.myPieces(myColor).length == 0) {
    return validMoves;
  }

  board.myPieces(myColor).forEach(rootPos => {
    Board.DIRS.forEach(dirPos => {
      let newPos = [(dirPos[0] + rootPos[0]), (dirPos[1] + rootPos[1])];
      if (!board.isValidPos(newPos)) {
        return;
      }
      let newPiece = board.grid[newPos[0]][newPos[1]];
      if (newPiece == undefined || newPiece.color == myColor) {
        return;
      } else if (expand(newPos, dirPos)) {
        validMoves.push(expand(newPos, dirPos));
      }
    })
  });
  return validMoves.sort();
};

module.exports = Board;
