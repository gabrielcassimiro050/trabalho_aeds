class cPlayer {
  PVector pos;
  PImage player;
  
  float a = 0;
  float anim;
  
  cInventario inventario;
    
  boolean flipped;
  boolean right, left, up, down; //Direções (Direita, Esquerda, Cima, Baixo)
  boolean abrirInventario;
  
  cPlayer(PVector pos) {
    this.pos = pos;
    player = new PImage();
    player = loadImage("ladrao.png");
    inventario = new cInventario();
  }

  void update() {
    int x = (int)pos.x;
    int y =(int) pos.y;
    int dx = 0, dy = 0;

    //Checa se os espaços são válidos
    if (right && checarColisao(xC(x+1), y)) {
      dx = 1;
      flipped = true;
    }
    if (left && checarColisao(xC(x-1), y)) {
      dx = -1;
      flipped = false;
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
      if (item.visivel && pos.x == item.pos.x && pos.y == item.pos.y) {
        if (item.valor>=8) coleta[1].play();
        else coleta[0].play();
        inventario.addItem(item);
        item.zeraItem();
      }
      
      //println(pos+" "+item.pos);
    }
  }

  void showPlayer() {
    fill(0);
    strokeWeight(5);
    stroke(50);
    imageMode(CENTER);
    pushMatrix();
    translate(pos.x*l+l/2, pos.y*h+h/2);
    if (flipped) scale(-1, 1);
    else scale(1, 1);
    //tint(255, 255, 255);

    image(player, 0, 0, l+anim*map(cos(a), -1, 1, 0, 1), h+anim*map(cos(a), -1, 1, 0, 1));
    anim = map(pitch.analyze(), 0, 500, 0, (l+h)/4);
    popMatrix();
    //rect(pos.x*l, pos.y*h, l, h);
    a+=.3;
    if(abrirInventario) inventario.showInventario();
  }
}
