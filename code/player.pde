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
    if (right && checarColisao(xC(x+1), y)) {
      dx = 1;
    }
    if (left && checarColisao(xC(x-1), y)) {
      dx = -1;
    }
    if (down && checarColisao(x, yC(y+1))) {
      dy = 1;
    }
    if (up && checarColisao(x, yC(y-1))) {
      dy = -1;
    }


    //Aplica nova posição
    if (grid[xC(x+dx)][yC(y+dy)].type != 2) {
      pos = new PVector(xC(x+dx), yC(y+dy));  
      if (pos.x == item.pos.x && pos.y == item.pos.y) item.zeraItem();
      //println(pos+" "+item.pos);
    }
  }
  
  void showPlayer() {
    fill(0);
    //strokeWeight(5);
    stroke(50);
    rect(pos.x*l, pos.y*h, l, h);
  }
}
