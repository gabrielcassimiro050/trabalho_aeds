class cItem {
  PVector pos;
  int valor;
  PImage img;
  boolean visivel;
  float a;

  //1 Marrom -- Bronze
  //2 Cinza -- Prata
  //3 Amarelo -- Ouro
  //4 Vermelho -- Rubi
  //5 Laranja -- Topázio
  //6 Roxo -- Ametista
  //7 Azul -- Safira
  //8 Rosa -- Rosa de Cristal
  //9 Ciano -- Diamante
  //10 Indigo -- Cosmos

  cItem() {
    img = new PImage();
    geraItem();
  }

  void updateTiles() {
    int x = (int)pos.x, y = (int)pos.y;
    for (int i = -1; i <= 1; ++i) {
      for (int j = -1; j <= 1; ++j) {
        grid[xC(x+i)][yC(y+j)].show();
      }
    }
  }

  void geraItem() {
    PVector aux = posicaoAleatoria();
    while (grid[(int)aux.x][(int)aux.y].type==2 || (aux.x == jogador.pos.x && aux.y == jogador.pos.y)) {
      aux = posicaoAleatoria();
    }
    pos = new PVector(aux.x, aux.y);
    valor = valorAleatorio();
    visivel = true;
    if (valor >= 1 && valor<=itens.length) img = itens[valor-1];
  }

  void showItem() {
    if (visivel) {
      updateTiles();
      imageMode(CORNER);
      image(img, pos.x*l, pos.y*h+cos(a)*2, l, h);
      a+=.3;
    }
  }

  void zeraItem() {
    updateTiles();
    visivel = false;
  }
}
