class tile{
  PVector pos;
  int tipo;



  tile(int x, int y, int tipo) {
    this.pos = new PVector(x, y);
    this.tipo = tipo;
  }

  void show() {
    int x = (int)pos.x, y = (int)pos.y;
    if (tipo==2) {


      //Coloca Grama ou Terra abaixo da Árvore
      noStroke();
      if (grid[x][yC(y-1)].tipo!=2) {
        fill(tiles[grid[x][yC(y-1)].tipo-1]);
      } else {
        fill(tiles[grid[x][yC(y+1)].tipo-1]);
      }

      imageMode(CORNER);
      tint(200, 255, 100, 255);
      image(tileSprites[0], x*l+xOffset, y*h+yOffset, l, h);

      //Organiza os sprites da Árvore para que estejam conectados

      tint(0, 255, 150, 255);
      if ((grid[xC(x+1)][y].tipo==2 || grid[xC(x-1)][y].tipo==2)) {
        if (grid[x][yC(y-1)].tipo==2) {
          if (grid[xC(x+1)][y].tipo==2) {
            image(tileSprites[5], x*l+xOffset, y*h+yOffset, l, h);
          } else {
            image(tileSprites[8], x*l+xOffset, y*h+yOffset, l, h);
          }
        } else {
          if (grid[xC(x+1)][y].tipo==2) {
            image(tileSprites[4], x*l+xOffset, y*h+yOffset, l, h);
          } else {
            image(tileSprites[9], x*l+xOffset, y*h+yOffset, l, h);
          }
        }
      } else {
        if (grid[x][yC(y-1)].tipo==2 && grid[x][yC(y+1)].tipo!=2) {
          image(tileSprites[7], x*l+xOffset, y*h+yOffset, l, h);
        } else {
          image(tileSprites[3], x*l+xOffset, y*h+yOffset, l, h);
        }
      }


      if (grid[xC(x+1)][y].tipo==2 && grid[xC(x-1)][y].tipo==2) {
        image(tileSprites[2], x*l+xOffset, y*h+yOffset, l, h);
      }

      if (grid[x][yC(y+1)].tipo==2) {
        if (grid[x][yC(y-1)].tipo==2 || grid[xC(x-1)][y].tipo==2 && grid[xC(x+1)][y].tipo==2) {
          image(tileSprites[0], x*l+xOffset, y*h+yOffset, l, h);
        }
        if (grid[xC(x+1)][y].tipo!=2 && grid[xC(x-1)][y].tipo!=2) {
          image(tileSprites[1], x*l+xOffset, y*h+yOffset, l, h);
        }
        if (grid[xC(x+1)][y].tipo!=2 && grid[xC(x-1)][y].tipo==2) {
          image(tileSprites[6], x*l+xOffset, y*h+yOffset, l, h);
        } else if (grid[xC(x+1)][y].tipo==2 && grid[xC(x-1)][y].tipo!=2) {
          image(tileSprites[10], x*l+xOffset, y*h+yOffset, l, h);
        }
      }

      tint(255, 255, 255, 255);
    } else {

      if (tipo!=3) {
        imageMode(CORNER);
        tint(200, 255, 100, 255);
        image(tileSprites[0], x*l+xOffset, y*h+yOffset, l, h);
        tint(255, 255, 255, 255);
      } else {
        noStroke();
        fill(tiles[tipo-1]);
        rect(x*l+xOffset, y*h+yOffset, l+1, h+1);
      }
    }
  }
}
