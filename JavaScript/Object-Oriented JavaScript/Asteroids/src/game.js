const Asteroid = require("./asteroid");

function Game () {
  this.asteroids = [];
  this.ship = [];
  this.bullets = [];
  this.addAsteroids();
}

Game.DIM_X = 500;
Game.DIM_Y = 500;
Game.NUM_ASTEROIDS = 4;

Game.prototype.checkCollisions = function () {
  for (let i = 0; i < this.asteroids.length; i++) {
    const rootAst = this.asteroids[i];
    for (let j = 0; j < this.asteroids.length; j++) {
      const compAst = this.asteroids[j];
      if (rootAst !== compAst && rootAst.isCollidedWith(compAst)) {
        console.log("Collision!");
      }
    }
  }
}

Game.prototype.step = function () {
  this.moveObjects();
  this.checkCollisions();
}

Game.prototype.addAsteroids = function () {
  for (let i = 0; i < Game.NUM_ASTEROIDS; i++) {
    let newAsteroid = new Asteroid( {
      pos: this.randomPosition(),
      game: this,
    } )
    this.asteroids.push(newAsteroid);
  }
}

Game.prototype.randomPosition = function () {
  let randX = Math.round(Math.random() * Game.DIM_X);
  let randY = Math.round(Math.random() * Game.DIM_Y);
  return [randX, randY]
}

Game.prototype.moveObjects = function () {
  for (let i = 0; i < this.asteroids.length; i++) {
    const element = this.asteroids[i];
    element.move();
  }
}

Game.prototype.draw = function (ctx) {
  ctx.clearRect(0, 0, Game.DIM_X, Game.DIM_Y);
  for (let i = 0; i < this.asteroids.length; i++) {
    const element = this.asteroids[i];
    element.draw(ctx);
  }
}

Game.prototype.wrap = function (pos) {
  let bleed = 30;
  if (pos[0] < (0 - bleed)) {
    return [(Game.DIM_X + bleed), pos[1]];
  } else if (pos[1] < (0 - bleed)) {
    return [pos[0], (Game.DIM_Y + bleed)];
  } else if (pos[0] > (Game.DIM_X + bleed)) {
    return [(0 - bleed), pos[1]];
  } else if (pos[1] > (Game.DIM_Y + bleed)) {
    return [pos[0], (0 - bleed)];
  } else {
    return pos;
  }
}

module.exports = Game;