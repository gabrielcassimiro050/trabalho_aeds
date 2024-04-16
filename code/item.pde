class cItem {
  PVector pos;
  int valor;
  color c;
  color[] cores = {#6F441C, #A5A4A3, #FFF750, #ED0A0A, #FC9103, #9002F0, #02A6F0, #FF79C7, #31FFD4, #1F2E7C};

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
    if (valor >= 1 && valor<=cores.length) this.c = cores[valor-1];
  }

  void geraItem() {
    PVector aux = posicaoAleatoria();
    println("novo item");
    while (grid[(int)aux.x][(int)aux.y]!=1 && jogador.pos==aux) {
      aux = posicaoAleatoria();
    }
    pos = aux;
    valor = valorAleatorio();
    if (valor >= 1 && valor<=cores.length) this.c = cores[valor-1];
  }
  
  void showItem() {
    fill(c);
    rect(pos.x*l, pos.y*h, l, h);
  }
  
  void zeraItem(){
    c = #72F08E;
    valor = 0;
    
  }
}
