class tile {
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
      imageMode(CORNER);
      tint(#74FF75, 255);
      //tint(lerpColor(#74FF75, #06B754, noise(x*escala, y*escala, seed)), 255);
      if (grid[x][yC(y-1)].tipo!=2) {
        if (grid[x][yC(y-1)].tipo==0 || grid[x][yC(y-1)].tipo==1) {
          image(gramaSprites[random(1)>.8 ? 1 : 0], x*l+xOffset, y*h+yOffset, l, h);
        }
        if (grid[x][yC(y-1)].tipo==3) {
          tint(255, 255);
          image(terraSprites[0], x*l+xOffset, y*h+yOffset, l, h);
        }
      } else if (grid[x][yC(y+1)].tipo!=2) {
        if (grid[x][yC(y+1)].tipo==0 || grid[x][yC(y+1)].tipo==1) {
          image(gramaSprites[random(1)>.8 ? 1 : 0], x*l+xOffset, y*h+yOffset, l, h);
        }
        if (grid[x][yC(y+1)].tipo==3) {
          tint(255, 255);
          image(terraSprites[0], x*l+xOffset, y*h+yOffset, l, h);
        }
      }

      //Organiza os sprites da Árvore para que estejam conectados
      tint(0, 255, 150, 255);
      if ((grid[xC(x+1)][y].tipo==2 || grid[xC(x-1)][y].tipo==2)) {
        if (grid[x][yC(y-1)].tipo==2) {
          if (grid[xC(x+1)][y].tipo==2) {
            image(arvoreSprites[5], x*l+xOffset, y*h+yOffset, l, h);
          } else {
            image(arvoreSprites[8], x*l+xOffset, y*h+yOffset, l, h);
          }
        } else {
          if (grid[xC(x+1)][y].tipo==2) {
            image(arvoreSprites[4], x*l+xOffset, y*h+yOffset, l, h);
          } else {
            image(arvoreSprites[9], x*l+xOffset, y*h+yOffset, l, h);
          }
        }
      } else {
        if (grid[x][yC(y-1)].tipo==2 && grid[x][yC(y+1)].tipo!=2) {
          image(arvoreSprites[7], x*l+xOffset, y*h+yOffset, l, h);
        } else {
          image(arvoreSprites[3], x*l+xOffset, y*h+yOffset, l, h);
        }
      }


      if (grid[xC(x+1)][y].tipo==2 && grid[xC(x-1)][y].tipo==2) {
        image(arvoreSprites[2], x*l+xOffset, y*h+yOffset, l, h);
      }

      if (grid[x][yC(y+1)].tipo==2) {
        if (grid[x][yC(y-1)].tipo==2 || grid[xC(x-1)][y].tipo==2 && grid[xC(x+1)][y].tipo==2) {
          image(arvoreSprites[0], x*l+xOffset, y*h+yOffset, l, h);
        }
        if (grid[xC(x+1)][y].tipo!=2 && grid[xC(x-1)][y].tipo!=2) {
          image(arvoreSprites[1], x*l+xOffset, y*h+yOffset, l, h);
        }
        if (grid[xC(x+1)][y].tipo!=2 && grid[xC(x-1)][y].tipo==2) {
          image(arvoreSprites[6], x*l+xOffset, y*h+yOffset, l, h);
        } else if (grid[xC(x+1)][y].tipo==2 && grid[xC(x-1)][y].tipo!=2) {
          image(arvoreSprites[10], x*l+xOffset, y*h+yOffset, l, h);
        }
      }
      tint(255, 255, 255, 255);
    } else {
      imageMode(CORNER);
      if (tipo==3) {
        image(terraSprites[0], x*l+xOffset, y*h+yOffset, l, h);
      } else {
        tint(#74FF75, 255);
        image(gramaSprites[tipo], x*l+xOffset, y*h+yOffset, l, h);
      }
      tint(255, 255, 255, 255);
    }
  }
}
