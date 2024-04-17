class cItem {
  PVector pos;
  int valor;
  color c;
  color[] cores = {#6F441C, #A5A4A3, #FFF750, #ED0A0A, #FC9103, #9002F0, #02A6F0, #FF79C7, #31FFD4, #1F2E7C};
  boolean visivel;
  float a;
  
  //1 Marrom
  //2 Cinza
  //3 Amarelo
  //4 Vermelho
  //5 Laranja
  //6 Roxo
  //7 Azul
  //8 Rosa
  //9 Ciano
  //10 Indigo

  cItem(PVector pos, int valor) {
    this.pos = pos;
    this.valor = valor;
    this.visivel = true;
    if (valor >= 1 && valor<=cores.length) this.c = cores[valor-1];
  }

  void geraItem() {
    PVector aux = posicaoAleatoria();
    while (grid[(int)aux.x][(int)aux.y]==2 || (jogador.pos.x==aux.x && jogador.pos.y==aux.y)) {
      aux = posicaoAleatoria();
    }
    pos = aux;
    valor = valorAleatorio();
    visivel = true;
    if (valor >= 1 && valor<=cores.length) this.c = cores[valor-1];
  }

  void showItem() {
    if (visivel) {
      fill(c);
      strokeWeight(5);
      stroke(lerpColor(c, 100, .5));
      ellipse(pos.x*l+l/2, pos.y*h+h/2, l+sin(a), h+cos(a));
      a+=.5;
    }
  }

  void zeraItem() {
    visivel = false;
  }
}
