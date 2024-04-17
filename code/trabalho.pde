int[][] grid;
int r = 20, c = 20; //Tamanho da grid
int time = 0, frame = 5;
float l, h; //Tamanho de cada espaço
cPlayer jogador;
cItem item;
boolean gerando = false;
long inicio, fim;
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

void showGrid() {
  
  for (int x = 0; x < r; ++x) {
    for (int y = 0; y < c; ++y) {
      strokeWeight(2);
      stroke(#446C23);
      fill(#72F08E);
      rect(x*l, y*h, l, h);
    }
  }
  
  //Evita que as bordas das árvores fiquem cortadas
  for (int x = 0; x < r; ++x) {
    for (int y = 0; y < c; ++y) {
      if (grid[x][y]==2) {
        strokeWeight(grid[x][y]==2? 5 : 2);
        stroke(#446C23);
        fill(#59B410);
        rect(x*l, y*h, l, h);
      }
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
  inicio = millis();
  fim = 0;
}

void draw() {
  background(255);

  showGrid();
  
  if (time%frame==0) jogador.update(); //Define a velocidade do jogador, aplicando um delay ao input de movimento


  //Checa se o número de iterações em segundos é múltiplo de 10
  if ((floor((fim-inicio)/(float)1000))!=0 && (floor((fim-inicio)/(float)1000))%10 == 0) {
    if (!gerando) {
      println("ok");
      item.geraItem();
      gerando = true;
    }
  }

  item.showItem();
  jogador.showPlayer();


  //Checa se o tempo anterior e o atual possuem uma diferença de 1 segundo
  //Para que não ocorra um bug em que o tempo permanece igual por um longo tempo...
  //[...] e faz com que o item seja gerado várias vezes
  long aux = millis();
  if ((floor((aux-inicio)/(float)1000))-(floor((fim-inicio)/(float)1000))==1) gerando = false;
  
  fim = millis();
  ++time;
}
