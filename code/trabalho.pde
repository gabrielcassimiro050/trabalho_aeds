import processing.sound.*;

cTile[][] grid;
int r = 30, c = 15; //Tamanho da grid
float l, h; //Tamanho de cada espaço

int time = 0, frame = 5;


float scl = .1; //Escala do Noise
float seed; //Seed do Noise

SoundFile musica;
SoundFile[] coleta;
PitchDetector pitch;
PImage[] itens;


cPlayer jogador;
cItem item;
cMenu menuInicial;
cMenu menuStart;
cMenu menuOps;



boolean gerando = false;
boolean game = false;

long inicio, fim;

color tiles[] = {#72F08E, #59B410, #FFF0B7, 0}; //Grama, Árvore, Terra, Aux
int colisao[] = {2}; //Árvore




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
      aux[x][y] = new cTile(x, y, random(1)<.9 ? 1 : 2); //Gera Árvores aleatórias
      if (aux[x][y].type==1 && random(1)>.5) aux[x][y] = new cTile(x, y, (int)map(round(noise(x*scl, y*scl, seed)), 0, 1, 1, 2)); //Gera uma camada de noise
      if (dist(x*l, y*h, round(r/2)*l, round(c/2)*h)<log(width+height)*10) aux[x][y] = new cTile(x, y, 1); //Limpa área ao redor do personagem
    }
  }
  return aux;
}


void eliminaVazios(int x, int y, int t) {
  if (t<(r*l+c*h)*2) {
    //println(x+" "+y);
    ++t;
    for (int i = -1; i <= 1; ++i) {
      if (grid[xC(x+i)][y].type != 2 && grid[xC(x+i)][y].type != 4) {
        grid[xC(x+i)][y] = new cTile(xC(x+i), y, 4); //Adiciona Aux a todo tile de Grama
        eliminaVazios(xC(x+i), y, t);
      }
    }
    for (int i = -1; i <= 1; ++i) {
      if (grid[x][yC(y+i)].type != 2 && grid[x][yC(y+i)].type != 4) {
        grid[x][yC(y+i)] = new cTile(x, yC(y+i), 4); //Adiciona Aux a todo tile de Grama
        eliminaVazios(x, yC(y+i), t);
      }
    }
  }
}

void checaGrid() {
  float seedAux = random(1000);
  for (int x = 0; x < r; ++x) {
    for (int y = 0; y < c; ++y) {
      if (grid[x][y].type == 1) grid[x][y] = new cTile(x, y, 2); //Troca Grama por Árvore
      if (grid[x][y].type == 4) grid[x][y] = new cTile(x, y, 1); //Troca Aux por Grama
      if (dist(x*l, y*h, floor(r/2)*l, floor(c/2)*h)<log(width+height)*10) grid[x][y] = new cTile(x, y, 3); //Adiciona Terra
      if (grid[x][y].type == 1) grid[x][y] = new cTile(x, y, round(noise(x*scl, y*scl, seedAux))==0 ? 1 : 3);
    }
  }
}

void showGrid() {
  for (int x = 0; x < r; ++x) {
    for (int y = 0; y < c; ++y) {
      grid[x][y].show();
    }
  }

  //Evita que as margens das árvores sejam cortadas;
  for (int x = 0; x < r; ++x) {
    for (int y = 0; y < c; ++y) {
      if (grid[x][y].type==2) {
        grid[x][y].show();
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

int segundos(long i, long f) {
  return floor((f-i)/(float)1000);
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
  case 'e':
    if (jogador.abrirInventario) jogador.abrirInventario = false;
    else jogador.abrirInventario = true;
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
void mousePressed() {
  if (menuInicial.visivel) {
    for (int i = 0; i < menuInicial.botoes.size(); ++i) {
      cBotao botao = menuInicial.botoes.get(i);
      botao.clicked();
    }
  }

  if (menuStart.visivel) {
    for (int i = 0; i < menuStart.botoes.size(); ++i) {
      cBotao botao = menuStart.botoes.get(i);
      botao.clicked();
    }
  }

  /*println(menuInicial.visivel);
   println(menuStart.visivel);
   println();*/
}

void mouseReleased() {
  if (menuInicial.visivel) {
    for (int i = 0; i < menuInicial.botoes.size(); ++i) {
      cBotao botao = menuInicial.botoes.get(i);
      if (botao.click) {
        if (botao.txt.equals("Game")) {
          menuInicial.visivel = false;
          menuStart.visivel = true;
        }
        if (botao.txt.equals("Sair")) exit();
      }
      menuInicial.botoes.get(i).click = false;
    }
  }

  if (menuStart.visivel) {
    for (int i = 0; i < menuStart.botoes.size(); ++i) {
      cBotao botao = menuStart.botoes.get(i);
      if (botao.click) {
        if (botao.txt.equals("Start")) {
          game = true;
        }
        if (botao.txt.equals("Voltar")) {
          menuStart.visivel = false;
          menuInicial.visivel = true;
        }
      }
      menuStart.botoes.get(i).click = false;
    }
  }
}

void setup() {
  size(1000, 500);
  background(0);
  rectMode(CENTER);
  rect(width/2, height/2, width/4, width/4);
  rectMode(CORNER);
  l = width/(float)r;
  h = height/(float)c;
  seed = random(100);
  grid = criarGrid();

  int x = floor(r/2);
  int y = floor(c/2);
  jogador = new cPlayer(new PVector(x, y));
  eliminaVazios(x, y, 0); //Seleciona os espaços impossíveis de chegar para remover
  checaGrid(); //Checa os espaços e remove eles

  itens = new PImage[10];

  musica = new SoundFile(this, "music.mp3");
  coleta = new SoundFile[2];
  for (int i = 0; i < coleta.length; ++i) coleta[i] = new SoundFile(this, "collect_"+i+".mp3");

  pitch = new PitchDetector(this, 0);
  pitch.input(musica);

  for (int i = 0; i < itens.length; ++i) itens[i] = loadImage("item_"+i+".png");
  item = new cItem();

  float mtx = width/1.5, mty = height/1.5;
  float mx = (width-mtx)/2, my = (height-mty)/2;
  menuInicial = new cMenu(mx, my, mtx, mty, true);
  menuInicial.addBotao(mx, my, mtx, mty/3, true, "Game");
  menuInicial.addBotao(mx, my+mty/3, mtx, mty/3, true, "Opções");
  menuInicial.addBotao(mx, my+2*mty/3, mtx, mty/3, true, "Sair");

  menuStart = new cMenu(mx, my, mtx, mty, false);
  menuStart.addBotao(mx, my, mtx, mty/3, true, "Start");
  menuStart.addBotao(mx, my+mty/3, mtx, mty/3, true, "Voltar");

  musica.amp(0);
  musica.play();
  musica.loop();
  inicio = millis();
  fim = 0;
}

void draw() {
  background(#58B2FF);
  if (game) {

    showGrid();

    if (time%frame==0) jogador.update(); //Define a velocidade do jogador, aplicando um delay ao input de movimento

    //Checa se o número de iterações em segundos é múltiplo de 10
    if (segundos(inicio, fim)!=0 && segundos(inicio, fim)%10 == 0) {
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
    if (segundos(inicio, aux)-segundos(inicio, fim)==1) gerando = false;

    fim = millis();
    ++time;
  } else {
    if (menuInicial.visivel) menuInicial.showMenu();
    if (menuStart.visivel) menuStart.showMenu();
  }
}
