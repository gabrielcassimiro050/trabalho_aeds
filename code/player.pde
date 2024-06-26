class player {
  PVector pos;
  float a = 0;
  float animacao;
  int score = 0;
  inventario inventario;

  boolean flipped;
  boolean right, left, up, down; //Direções (Direita, Esquerda, Cima, Baixo)
  boolean abrirInventario;

  player(PVector pos) {
    this.pos = pos;
    inventario = new inventario();
  }


  void updateTiles() {
    int x = (int)pos.x, y = (int)pos.y;
    int ix = (int)item.pos.x, iy = (int)item.pos.y;
    //Atualiza todos os arvoreSpritess em volta de uma vez, sem contar o item
    for (int i = -1; i <= 1; ++i) {
      for (int j = -1; j <= 1; ++j) {
        if (!(item.visivel && ix==xC(x+i) && iy==yC(y+j))) grid[xC(x+i)][yC(y+j)].show();
      }
    }
  }

  void update() {
    int x = (int)pos.x, y = (int)pos.y;
    int dx = 0, dy = 0;

    //Checa se os espaços são válidos
    if (right && checarColisao(xC(x+1), y)) {
      dx += 1;
      flipped = true;
    }
    if (left && checarColisao(xC(x-1), y)) {
      dx += -1;
      flipped = false;
    }
    if (down && checarColisao(x, yC(y+1))) {
      dy += 1;
    }
    if (up && checarColisao(x, yC(y-1))) {
      dy += -1;
    }

    //Aplica nova posição
    if (checarColisao(xC(x+dx), yC(y+dy))) {
      updateTiles();
      pos = new PVector(xC(x+dx), yC(y+dy));
      if (item.visivel && x == item.pos.x && y == item.pos.y) {
        item.zeraItem();

        if (item.valor>=8) coleta[1].play();
        else coleta[0].play();

        score+=item.valor;
        inventario.addItem(item);
      }
    }
  }

  void show() {
    updateTiles();
    imageMode(CENTER);
    pushMatrix();
    translate(pos.x*l+l/2+xOffset, pos.y*h+h/2+yOffset);
    if (flipped) scale(-1, 1);
    else scale(1, 1);
    if (game) {
      rotate(sin(a)/100*pitch.analyze()/((r+c)/2));
      image(playerSprite, 0, 0, l+animacao*map(cos(a), -1, 1, 0, 1)/l, h+animacao*map(cos(a), -1, 1, 0, 1)/h);
      animacao = pitch.analyze()/((r+c)/2);
      a+=.3;
    } else {
      if (animacao<=1) {
        image(playerSprite, 0, 0, l+map(cos(a), -1, 1, 0, 1)*animacao, h+map(sin(a), -1, 1, 0, 1)*animacao);
      } else {
        if (animacao<1.5) {
          playerSprite = loadImage("ladrao.png");
          image(playerSprite, 0, 0, l+animacao*map(cos(a), -1, 1, 0, 1)/l, h+animacao*map(cos(a), -1, 1, 0, 1)/h);
        } else if (animacao<1.7) {
          image(playerSprite, 0, 0, l+map(cos(a), -1, 1, 0, 1)*animacao, h+map(sin(a), -1, 1, 0, 1)*animacao);
        } else if (animacao<2) {
          image(playerSprite, 0, 0, l+animacao*map(cos(a), -1, 1, 0, 1)/l, h+animacao*map(cos(a), -1, 1, 0, 1)/h);
        } else {
          image(playerSprite, 0, 0, l+map(cos(a), -1, 1, 0, 1)*animacao, h+map(sin(a), -1, 1, 0, 1)*animacao);
        }
      }
      if (animacao<=2) {
        animacao+=.1;
      } else {
        if (!musicaFinal.isPlaying()) musicaFinal.play();
        fim = true;
      }

      a+=.5;
    }
    popMatrix();

    if (abrirInventario) inventario.show();
  }
}
