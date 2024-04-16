int[][] grid;
int r = 100, c = 100; //Tamanho da grid
int time = 0, frame = 5;
float l, h; //Tamanho de cada espaço
cPlayer jogador;
cItem item;
cContador contador;
boolean contando, contaFinalizada;
//1 Grama
//2 Árvore




int[][] criarGrid() {
  int[][] aux = new int[r][c];
  for (int x = 0; x < r; ++x) {
    for (int y = 0; y < c; ++y) {
      aux[x][y] = random(1)<.9 ? 1 : 2;
    }
  }
  return aux;
}


int valorAleatorio() {
  return ceil(random(10));
}

PVector posicaoAleatoria() {
  return new PVector(floor(random(r)), floor(random(c)));
}




void contar(int tempo) {
  contador = new cContador(tempo); //Criar um objeto da classe cContador
  new Thread(contador).start(); //Engloba o objeto em uma thread
}

void showGrid() {
  for (int x = 0; x < r; ++x) {
    for (int y = 0; y < c; ++y) {
      noStroke();
      //strokeWeight(1);
      //stroke(#446C23);
      fill(#72F08E);
      if (grid[x][y]==2) fill(#59B410);
      rect(x*l, y*h, l, h);
    }
  }
}



//Movimentação
void keyPressed() {
  switch(key) {
  case 'd':
    jogador.right = true;
    break;
  case 'a':
    jogador.left = true;
    break;
  case 'w':
    jogador.up = true;
    break;
  case 's':
    jogador.down = true;
    break;
  }
  switch(keyCode) {
  case RIGHT:
    jogador.right = true;
    break;
  case LEFT:
    jogador.left = true;
    break;
  case UP:
    jogador.up = true;
    break;
  case DOWN:
    jogador.down = true;
    break;
  }
}

void keyReleased() {
  switch(key) {
  case 'd':
    jogador.right = false;
    break;
  case 'a':
    jogador.left = false;
    break;
  case 'w':
    jogador.up = false;
    break;
  case 's':
    jogador.down = false;
    break;
  }
  switch(keyCode) {
  case RIGHT:
    jogador.right = false;
    break;
  case LEFT:
    jogador.left = false;
    break;
  case UP:
    jogador.up = false;
    break;
  case DOWN:
    jogador.down = false;
    break;
  }
}

void setup() {
  size(500, 500);
  l = width/(float)r;
  h = height/(float)c;
  grid = criarGrid();
  jogador = new cPlayer(new PVector(floor(r/2), floor(c/2)));
  item = new cItem(posicaoAleatoria(), valorAleatorio());
  contador = new cContador(0);
}

void draw() {
  background(255);
  showGrid();
  if (time%frame==0) jogador.update();

  if (!contando) {
    contar(10);
  }

  if (contaFinalizada) {
    item.geraItem();
    contaFinalizada = false;
  }

  item.showItem();
  jogador.showPlayer();
  ++time;
  //if(mousePressed) setup();
}
