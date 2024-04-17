cTile[][] grid;
int r = 10, c = 10; //Tamanho da grid
int time = 0, frame = 5;
float l, h; //Tamanho de cada espaço
float scl = .1;
float seed;
cPlayer jogador;
cItem item;
boolean gerando = false;
long inicio, fim;


color tiles[] = {#72F08E, #59B410, #FFF0B7, 0}; //Grama, Árvore, Terra, Aux
int colisao[] = {2};




//Garante que as coordenadas estejam dentro da grid
int xC(int x) {
  return (x+r)%r;
}
int yC(int y) {
  return (y+c)%c;
}




//Funções da Grid---------------------------------------------------------------------------------------
boolean checarColisao(int x, int y) {
  for (int i = 0; i < colisao.length; ++i) {
    if (grid[x][y].type==colisao[i]) return false;
  }
  return true;
}

cTile[][] criarGrid() {
  cTile[][] aux = new cTile[r][c];
  for (int x = 0; x < r; ++x) {
    for (int y = 0; y < c; ++y) {
      aux[x][y] = new cTile(x, y, random(1)<.9 ? 1 : 2);
      if (aux[x][y].type==1) aux[x][y].type = (int)map(round(noise(x*scl, y*scl, seed)), 0, 1, 1, 2);
      if (dist(x*l, y*h, round(r/2)*l, round(c/2)*h)<(r+c)*2) aux[x][y].type = 1;
    }
  }
  return aux;
}


void eliminaVazios(int x, int y, int t) {
  if (t<(width+height)*2) {
    //println(x+" "+y);
    ++t;
    for (int i = -1; i <= 1; ++i) {
      if (grid[xC(x+i)][y].type != 2 && grid[xC(x+i)][y].type != 4) {
        grid[xC(x+i)][y] = new cTile(xC(x+i), y, 4);
        eliminaVazios(xC(x+i), y, t);
      }
    }
    for (int i = -1; i <= 1; ++i) {
      if (grid[x][yC(y+i)].type != 2 && grid[x][yC(y+i)].type != 4) {
        grid[x][yC(y+i)] = new cTile(x, yC(y+i), 4);
        eliminaVazios(x, yC(y+i), t);
      }
    }
  }
}

void checaGrid(){
  for (int x = 0; x < r; ++x) {
    for (int y = 0; y < c; ++y) {
      if (grid[x][y].type == 1) grid[x][y] = new cTile(x, y, 2);//fill(0, 200, 0);
      if (grid[x][y].type == 4) grid[x][y] = new cTile(x, y, 1);//fill(255);
      if (dist(x*l, y*h, floor(r/2)*l, floor(c/2)*h)<(r+c)) grid[x][y] = new cTile(x, y, 3);
    }
  }
}

void showGrid() {

  for (int x = 0; x < r; ++x) {
    for (int y = 0; y < c; ++y) {
      //strokeWeight(2);
      stroke(lerpColor(tiles[grid[x][y].type-1], 0, .5));
      fill(tiles[grid[x][y].type-1]);
      rect(x*l, y*h, l, h);
    }
  }

  //Evita que as bordas das árvores fiquem cortadas
  for (int x = 0; x < r; ++x) {
    for (int y = 0; y < c; ++y) {
      if (grid[x][y].type==2) {
        //strokeWeight(grid[x][y]==2? 5 : 2);
        stroke(lerpColor(tiles[grid[x][y].type-1], 0, .5));
        fill(tiles[grid[x][y].type-1]);
        rect(x*l, y*h, l, h);
      }
    }
  }
}

//-------------------------------------------------------------------------------------------------------



int valorAleatorio() {
  return ceil(random(10));
}

PVector posicaoAleatoria() {
  return new PVector(floor(random(r)), floor(random(c)));
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
  seed = random(100);
  grid = criarGrid();
  int x = floor(r/2);
  int y = floor(c/2);
  jogador = new cPlayer(new PVector(x, y));
  eliminaVazios(x, y, 0); //Seleciona os espaços impossíveis de chegar para remover
  checaGrid(); //Checa os espaços e remove eles
  item = new cItem();
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
      //println("ok");
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
