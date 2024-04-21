import processing.sound.*;

cTile[][] grid;
int r = 25, c = 25; //Tamanho da grid
float l, h; //Tamanho de cada espaço

int time = 0, frame = floor(100/floor((r+c)/4));


float scl = .1; //Escala do Noise
float seed; //Seed do Noise

float mundoX, mundoY;
float mundoSX, mundoSY;

SoundFile musica;
SoundFile[] coleta;
PitchDetector pitch;
PImage[] itens;
PImage[] tile;
PImage loading;

color layout = color(0, 255, 0, 255);

cPlayer jogador;
cItem item;
cMenu menuInicial;
cMenu menuStart;
cMenu menuOps;



boolean gerando = false;
boolean mapaExpandido = false;
boolean game = false, gaming;

long inicio, fim;

color tiles[] = {0, #59B410, #FFF0B7, 0}; //Grama, Árvore, Terra, Aux
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
      if (aux[x][y].type==1 && random(1)>.5 && mapaExpandido) aux[x][y] = new cTile(x, y, (int)map(round(noise(x*scl, y*scl, seed)), 0, 1, 1, 2)); //Gera uma camada de noise
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
  //println(layout);
  tiles[0] = lerpColor(layout, color(255, 255), .5);
  for (int x = 0; x < r; ++x) {
    for (int y = 0; y < c; ++y) {
      grid[x][y].show();
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
    if (jogador.abrirInventario) {
      jogador.abrirInventario = false;
      showGrid();
    } else {
      jogador.abrirInventario = true;
    }
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
  case '1':
    layout = color(0, 255, 100, 255);
    showGrid();
    break;
  case '2':
    layout = color(0, 255, 200, 255);
    showGrid();
    break;
  case '3':
    layout = color(255, 100, 0, 255);
    showGrid();
    break;
  case '4':
    layout = color(255, 255, 255, 255);
    showGrid();
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
  case BACKSPACE:
    setup();
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
    for (int i = 0; i < menuStart.checkboxes.size(); ++i) {
      cCheckbox checkbox = menuStart.checkboxes.get(i);
      checkbox.clicked();
    }
  }
}

void mouseReleased() {

  //Menu Inicial--------------------------------
  if (menuInicial.visivel) {
    cBotao game = menuInicial.getBotao("Game");
    cBotao sair = menuInicial.getBotao("Sair");

    if (game.click) {
      menuInicial.visivel = false;
      menuStart.visivel = true;
      game.click = false;
    }
    if (sair.click) {
      exit();
    }
  }
  //--------------------------------------------

  //Menu Start----------------------------------
  if (menuStart.visivel) {
    cBotao start = menuStart.getBotao("Start");
    cBotao voltar = menuStart.getBotao("Voltar");
    cCheckbox expandido = menuStart.getCheckbox("Expandido");
    cCheckbox estacoes = menuStart.getCheckbox("Estações");
    cBotao primavera = menuStart.getBotao("Primavera");
    cBotao verao = menuStart.getBotao("Verão");
    cBotao outono = menuStart.getBotao("Outono");
    cBotao inverno = menuStart.getBotao("Inverno");

    if (start.click) {
      menuStart.visivel = false;
      background(#0C1B3B);
      imageMode(CENTER);
      image(loading, width/2, height/2, 320, 160);
      game = true;
      start.click = false;
    }

    if (voltar.click) {
      menuStart.visivel = false;
      menuInicial.visivel = true;
      voltar.click = false;
    }


    if (expandido.click) {
      if (!mapaExpandido) {
        mapaExpandido = true;
        grid = criarGrid();
        eliminaVazios(floor(r/2), floor(c/2), 0); //Seleciona os espaços impossíveis de chegar para remover
        checaGrid();
      }
    } else {
      if (mapaExpandido) {
        mapaExpandido = false;
        grid = criarGrid();
        eliminaVazios(floor(r/2), floor(c/2), 0); //Seleciona os espaços impossíveis de chegar para remover
        checaGrid();
      }
    }

    if (primavera.click) {
      estacoes.click = false;
      layout = color(0, 255, 100, 255);
      primavera.click = false;
    }
    if (verao.click) {
      estacoes.click = false;
      layout = color(0, 255, 200, 255);
      verao.click = false;
    }
    if (outono.click) {
      estacoes.click = false;
      layout = color(255, 100, 0, 255);
      outono.click = false;
    }
    if (inverno.click) {
      estacoes.click = false;
      layout = color(255, 255, 255, 255);
      inverno.click = false;
    }

    if (estacoes.click) {
      primavera.visivel = true;
      verao.visivel = true;
      outono.visivel = true;
      inverno.visivel = true;
    } else {
      primavera.visivel = false;
      verao.visivel = false;
      outono.visivel = false;
      inverno.visivel = false;
    }
  }

  //--------------------------------------------
}

void setup() {
  size(700, 700);
  background(0);

  //Tela de Loading
  rectMode(CENTER);
  rect(width/2, height/2, width/4, width/4);
  rectMode(CORNER);



  l = width/(float)r;
  h = height/(float)c;

  //Define o menu inicial
  float mtx = width/1.5, mty = height/1.5;
  float mx = (width-mtx)/2, my = (height-mty)/2;
  menuInicial = new cMenu(mx, my, mtx, mty, true);
  menuInicial.addBotao(mx, my, mtx, mty/3, true, "Game");
  menuInicial.addBotao(mx, my+mty/3, mtx, mty/3, true, "Opções");
  menuInicial.addBotao(mx, my+2*mty/3, mtx, mty/3, true, "Sair");

  //Define o menu de start
  menuStart = new cMenu(mx, my, mtx, mty, false);


  menuStart.addBotao((mtx/2-mtx/2.5)/2+mx+mtx/2, my+(mty/2-mty/2.5)/2, mtx/2.5, mty/2.5, true, "Personagem");
  mundoX = (mtx/2-mtx/2.5)/2+mx;
  mundoY = my+(mty/2-mty/2.5)/2;
  mundoSX = mtx/2.5;
  mundoSY = mty/2.5;
  menuStart.addBotao(mundoX, mundoY, mundoX+r*(mundoX/mundoSX), mundoY+c*(mundoY/mundoSY), false, "Mundo");

  menuStart.addCheckbox(mundoX, mundoY+mty/5+mty/20+mty/6, mtx/2.5, mty/10, true, "Expandido");

  menuStart.addCheckbox(mundoX, my+(mty/2-mty/2.5)/2+mty/2.4+mty/6, mtx/2.5, mty/10, true, "Estações");
  menuStart.addBotao(mundoX+mtx/15, mundoY+mty/2.4+(2*mty/20)+mty/6, mtx/2.5-mtx/15, mty/20, true, "Primavera");
  menuStart.addBotao(mundoX+mtx/15, mundoY+mty/2.4+(3*mty/20)+mty/6, mtx/2.5-mtx/15, mty/20, true, "Verão");
  menuStart.addBotao(mundoX+mtx/15, mundoY+mty/2.4+(4*mty/20)+mty/6, mtx/2.5-mtx/15, mty/20, true, "Outono");
  menuStart.addBotao(mundoX+mtx/15, mundoY+mty/2.4+(5*mty/20)+mty/6, mtx/2.5-mtx/15, mty/20, true, "Inverno");

  grid = criarGrid();
  eliminaVazios(floor(r/2), floor(c/2), 0); //Seleciona os espaços impossíveis de chegar para remover
  checaGrid();

  menuStart.addBotao(mundoX+mtx/2, my+mty-mty/8-mty/10-10, mtx/2.5, mty/10, true, "Start");
  menuStart.addBotao(mundoX+mtx/2, my+mty-mty/8, mtx/2.5, mty/10, true, "Voltar");
  




  //Carrega os sons
  musica = new SoundFile(this, "music.mp3");
  coleta = new SoundFile[2];
  for (int i = 0; i < coleta.length; ++i) coleta[i] = new SoundFile(this, "collect_"+i+".mp3");

  //Carrega tela de loading
  loading = new PImage();
  loading = loadImage("loading.png");

  //Toca a musica
  musica.play();
  musica.loop();

  inicio = millis();
  fim = 0;

  gaming = false;
}

void draw() {
  if (game) {

    if (!gaming) {
      //seed = random(100);
      int x = floor(r/2);
      int y = floor(c/2);
      jogador = new cPlayer(new PVector(x, y));
      /*grid = criarGrid();

      
      eliminaVazios(x, y, 0, grid); //Seleciona os espaços impossíveis de chegar para remover
      checaGrid(grid); //Checa os espaços e remove eles
      */
      //Carrega os sprites dos itens
      itens = new PImage[10];
      for (int i = 0; i < itens.length; ++i) itens[i] = loadImage("item_"+i+".png");
      item = new cItem();
      //Carrega os sprites dos tiles
      tile = new PImage[8];
      for (int i = 0; i < tile.length; ++i) tile[i] = loadImage("tile_"+i+".png");

      //Define e coloca input no PitchDetector (Detecta a nota fundamental)
      pitch = new PitchDetector(this, 0);
      pitch.input(musica);

      //Carrega o grid inteiro apenas na primeira iteração
      showGrid();
    }

    gaming = true;

    //Define a velocidade do jogador, aplicando um delay ao input de movimento
    if (time%frame==0) jogador.update();

    //Checa se o número de iterações em segundos é múltiplo de 10
    if (segundos(inicio, fim)!=0 && segundos(inicio, fim)%10 == 0) {
      if (!gerando) {
        item.zeraItem();
        item.geraItem();
        gerando = true;
      }
    }

    //Mostra o item e o jogador
    if (!jogador.abrirInventario) item.showItem();
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
    if (menuStart.visivel) {
      menuStart.showMenu();
      float lm = mundoSX/(float)r, hm = mundoSY/(float)c;
      tiles[0] = lerpColor(layout, color(255, 255), .5);
      tiles[1] = lerpColor(layout, color(100, 255), .5);
      for (int x = 0; x < r; ++x) {
        for (int y = 0; y < c; ++y) {
          noStroke();
          //mundo[x][y].show();
          fill(tiles[grid[x][y].type-1]);
          rect(mundoX+x*lm, mundoY+y*hm, lm, hm);
          //aux[x][y] = new cTile(x, y, random(1)<.9 ? 1 : 2); //Gera Árvores aleatórias
          //if (aux[x][y].type==1 && random(1)>.5 && mapaExpandido) aux[x][y] = new cTile(x, y, (int)map(round(noise(x*scl, y*scl, seed)), 0, 1, 1, 2)); //Gera uma camada de noise
          //if (dist(x*l, y*h, round(r/2)*l, round(c/2)*h)<log(width+height)*10) aux[x][y] = new cTile(x, y, 1); //Limpa área ao redor do personagem
        }
      }
    }
  }
}
