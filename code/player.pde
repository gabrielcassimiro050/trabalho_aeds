class cPlayer {
  PVector pos;
  boolean right, left, up, down; //Direções (Direita, Esquerda, Cima, Baixo)

  cPlayer(PVector pos) {
    this.pos = pos;
  }

  void update() {
    int x = (int)pos.x;
    int y =(int) pos.y;
    int dx = 0, dy = 0;
    
    //Checa se os espaços são válidos
    if (x+1<r && right && grid[x+1][y] == 1) {
      dx = 1;
    }
    if (x-1>=0 && left && grid[x-1][y] == 1) {
      dx = -1;
    }
    if (y+1<c && down && grid[x][y+1] == 1) {
      dy = 1;
    }
    if (y-1>=0 && up && grid[x][y-1] == 1) {
      dy = -1;
    }


    //Aplica nova posição
    if (grid[x+dx][y+dy] != 2 && x+dx<r && x+dx>=0 && y+dy<c && y+dy>=0) {
      pos = new PVector(x+dx, y+dy);  
      if (pos.x == item.pos.x && pos.y == item.pos.y) item.zeraItem();
      //println(pos+" "+item.pos);
    }
  }
  
  void showPlayer() {
    fill(0);
    strokeWeight(5);
    stroke(50);
    rect(pos.x*l, pos.y*h, l, h);
  }
}
