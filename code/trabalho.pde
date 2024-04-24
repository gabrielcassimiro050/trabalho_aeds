import processing.sound.*;

cTile[][] grid;
int r = 10, c = 10; //Tamanho da grid
float l, h; //Tamanho de cada espaço
float xOff, yOff; //Offset da grid

int timeFrame = 0, frame = floor(10/floor(log(r+c)));

int time = 0; //Tempo desde do início do jogo
int timeGame = 0; //Tempo em jogo
int timeMax = 120; //Tempo máximo de jogo

float scl = .1; //Escala do Noise
float seed; //Seed do Noise

float mundoX, mundoY; //POsições da preview
float mundoSX, mundoSY; //Tamanhos da preview

SoundFile musica;
SoundFile[] coleta;
PitchDetector pitch;
PImage[] itens;
PImage[] tile;
PImage player;
PImage loading;
PImage timeBoard, scoreBoard;
PFont pixelFont;

cPlayer jogador;
cItem item;
cMenu menuInicial;
cMenu menuStart;



boolean contando = false;
boolean mapaExpandido = false;
boolean game = false, gaming;
boolean paused = false;

long inicio, fim;

color tiles[] = {#8CFC98, #59B410, #FFF0B7, 0}; //Grama, Árvore, Terra, Aux
int colisao[] = {2}; //Árvore




//Garantem que as coordenadas estejam dentro da grid
int xC(int x) {
  return (x+r)%r;
}
int yC(int y) {
  return (y+c)%c;
}




//Funções da Grid---------------------------------------------------------------------------------------
//Implementação que permite adicionar outros obstáculos
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
      if (dist(x*l, y*h, round(r/2.0)*l, round(c/2.0)*h)<log(width+height)*10) aux[x][y] = new cTile(x, y, 1); //Limpa área ao redor do personagem
    }
  }
  return aux;
}


void eliminaVazios(int x, int y, int t) {
  if (t<(r*2+c*2)*2){
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
      if (dist(x*l, y*h, floor(r/2.0)*l, floor(c/2.0)*h)<log(width+height)*10) grid[x][y] = new cTile(x, y, 3); //Adiciona Terra
      if (grid[x][y].type == 1) grid[x][y] = new cTile(x, y, round(noise(x*scl, y*scl, seedAux))==0 ? 1 : 3);
    }
  }
}

void showGrid() {
  background(#0C1B3B);
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

//Transforma ms em s
int segundos(long i, long f) {
  return floor((f-i)/(float)1000);
}

//Movimentação
void keyPressed() {
  if (game) {
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
}

void keyReleased() {
  for (int i = 0; i < menuStart.textboxes.size(); ++i) {
    cTextbox textbox = menuStart.textboxes.get(i);
    if (textbox.click) {
      if (keyCode==BACKSPACE) textbox.txt = new String();

      if (textbox.txt!=null && Character.isDigit(key)) {
        if (!textbox.txt.equals("0")) {
          textbox.txt = textbox.txt.concat(Character.toString(key));
        } else {
          textbox.txt = Character.toString(key);
        }
      } else if (keyCode!=ENTER) {
        textbox.txt = "0";
      }

      if (keyCode==ENTER) {
        if (textbox.txt=="0") textbox.txt = "1";
        textbox.txt = Integer.valueOf(textbox.txt)<=250 ? textbox.txt : "250";
        if (textbox.nome.equals("R")) r = Integer.valueOf(textbox.txt);
        if (textbox.nome.equals("C")) c = Integer.valueOf(textbox.txt);
        l = width/(float)r;
        h = height/(float)c;
        grid = criarGrid();
        eliminaVazios(floor(r/2.0), floor(c/2.0), 0);
        checaGrid();
      }
    }
  }
  if (game) {
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
    for (int i = 0; i < menuStart.textboxes.size(); ++i) {
      cTextbox textbox = menuStart.textboxes.get(i);
      textbox.clicked();
      if (textbox.click) textbox.txt = "0";
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
    cBotao randomSeed = menuStart.getBotao("Random Seed");
    cCheckbox expandido = menuStart.getCheckbox("Expandido");

    if (start.click) {
      menuStart.visivel = false;
      background(#0C1B3B);
      imageMode(CENTER);
      image(loading, width/2.0, height/2.0, 320, 160);
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
        eliminaVazios(floor(r/2.0), floor(c/2.0), 0);
        checaGrid();
      }
    } else {
      if (mapaExpandido) {
        mapaExpandido = false;
        grid = criarGrid();
        eliminaVazios(floor(r/2.0), floor(c/2.0), 0);
        checaGrid();
      }
    }

    if (randomSeed.click) {
      seed = random(100);
      grid = criarGrid();
      eliminaVazios(floor(r/2.0), floor(c/2.0), 0);
      checaGrid();
      randomSeed.click = false;
    }
  }
  //--------------------------------------------
}

void setup() {
  size(750, 750);
  background(#0C1B3B);

  //Tela de Loading
  rectMode(CENTER);
  rect(width/2.0, height/2.0, width/4.0, width/4.0);
  rectMode(CORNER);

  l = width/(float)r;
  h = height/(float)c;

  //Define o tamanho dos menus e suas posições
  float mtx = width/1.5, mty = height/1.5;
  float mx = (width-mtx)/2.0, my = (height-mty)/2.0;

  //Define as proporções da preview
  mundoX = (mtx/2.0-mtx/2.5)/2+mx;
  mundoY = my+(mty/2.0-mty/2.5)/2;
  mundoSX = mtx/2.5;
  mundoSY = mty/2.5;

  //Define o menu Inicial
  menuInicial = new cMenu(mx, my, mtx, mty, true);
  menuInicial.addBotao(mx, my, mtx, mty/3.0, true, "Game");
  menuInicial.addBotao(mx, my+2*mty/3.0, mtx, mty/3.0, true, "Sair");

  //Define o menu de Start e seus acessórios se baseando na posição da preview
  menuStart = new cMenu(mx, my, mtx, mty, false);
  menuStart.addBotao(mundoX, mundoY, mundoX+r*(mundoX/mundoSX), mundoY+c*(mundoY/mundoSY), false, "Mundo"); //Placeholder da preview
  menuStart.addCheckbox(mundoX, mundoY+mty/5.0+mty/20.0+mty/6.0, mtx/2.5, mty/10.0, true, "Expandido");
  menuStart.addBotao(mundoX, mundoY+mty/5.0+mty/20.0+mty/6+mty/10.0, mtx/2.5, mty/10.0, true, "Random Seed");

  menuStart.addTextbox(mundoX, mundoY+mty/5.0+mty/20+mty/6+mty/5.0, mtx/2.5, mty/10.0, true, "R", "10");
  menuStart.addTextbox(mundoX, mundoY+mty/5.0+mty/20.0+mty/6.0+mty/5.0+mty/10.0, mtx/2.5, mty/10.0, true, "C", "10");

  menuStart.addBotao(mundoX+mtx/2.0, my+mty-mty/8.0-mty/10.0-10, mtx/2.5, mty/10.0, true, "Start");
  menuStart.addBotao(mundoX+mtx/2.0, my+mty-mty/8.0, mtx/2.5, mty/10.0, true, "Voltar");

  //Cria o que servirá para a preview inicial
  grid = criarGrid();
  eliminaVazios(floor(r/2.0), floor(c/2.0), 0);
  checaGrid();

  //Carrega os sons
  musica = new SoundFile(this, "music.mp3");
  coleta = new SoundFile[2];
  for (int i = 0; i < coleta.length; ++i) coleta[i] = new SoundFile(this, "collect_"+i+".mp3");

  //Carrega tela de loading
  loading = new PImage();
  loading = loadImage("loading.png");

  //Carrega jogador
  player = new PImage();
  player = loadImage("ladrao.png");

  //Carrega fonte
  pixelFont = createFont("Minecraft.ttf", 20);
  textFont(pixelFont);

  //Toca a musica
  musica.play();
  musica.loop();

  inicio = millis();
  fim = 0;

  gaming = false;
}

void draw() {
  if (game) {

    //Carregamento
    if (!gaming) {
      //seed = random(100);
      background(#0C1B3B);
      int x = floor(r/2.0);
      int y = floor(c/2.0);
      jogador = new cPlayer(new PVector(x, y));

      //Carrega os sprites dos itens
      itens = new PImage[10];
      for (int i = 0; i < itens.length; ++i) itens[i] = loadImage("item_"+i+".png");
      item = new cItem();

      //Carrega os sprites dos tiles
      tile = new PImage[11];
      for (int i = 0; i < tile.length; ++i) tile[i] = loadImage("tile_"+i+".png");


      //Carrega os sprites do time e score
      timeBoard = new PImage();
      scoreBoard = new PImage();
      timeBoard = loadImage("time.png");
      scoreBoard = loadImage("score.png");

      //Define e coloca input no PitchDetector (Detecta a nota fundamental)
      pitch = new PitchDetector(this, 0);
      pitch.input(musica);

      //Calcula o offset do mapa
      if (c>r) {
        l*=(r/(float)c);
        xOff = (width-r*l)/2.0;
      }
      if (r>c) {
        h*=(c/(float)r);
        yOff = (height-c*h)/2.0;
      }
      showGrid();
    }

    gaming = true;

    //Define a velocidade do jogador, aplicando um delay ao input de movimento
    if (timeFrame%frame==0 && !paused) jogador.update();

    //Gera o item enquanto não estiver pausado e 10 segundos passaram
    if (time%10 == 0 && !contando && !paused) {
      item.zeraItem();
      item.geraItem();
    }

    //Conta o tempo de jogo enquanto não estiver pausado e 1 segundo passar
    if (time%1 == 0 && !contando && !paused) {
      timeGame++;
    }

    //Checa se o jogo ainda não acabou
    if (timeMax-timeGame<=0 && contando) game = false;

    //Mostra o jogador e o item
    if (!jogador.abrirInventario) item.show();
    jogador.show();

    //Checa se o inventário está aberto e pausa o jogo
    if (!jogador.abrirInventario) {

      paused = false;
      contando = false;
      image(timeBoard, width*.08, height*.04, width*.16, height*.08);
      image(scoreBoard, width-width*.08, height*.04, width*.16, height*.08);
      fill(#82441a);
      text((timeMax-timeGame)/60+":"+nf((timeMax-timeGame)%60, 2), width/25.0, height/20.0);
      text(nf(jogador.score, 4), width-width/10.0, height/20.0);
    } else {
      contando = true;
      paused = true;
      fill(255);
      text((timeMax-timeGame)/60+":"+nf((timeMax-timeGame)%60, 2), width/25.0, height-height/20.0);
      text(nf(jogador.score, 4), width-width/10.0, height-height/20.0);
    }



    //Conta os segundos
    long aux = millis();
    if (segundos(inicio, aux)-segundos(inicio, fim)==1) {
      ++time;
      contando = false;
    } else {
      contando = true;
    }
    fim = millis();

    ++timeFrame;
  } else {
    if (menuInicial.visivel) menuInicial.show();
    if (menuStart.visivel) {
      menuStart.show();

      //Cria a preview do mapa
      float lm = mundoSX/(float)r, hm = mundoSY/(float)c;
      float xOffm = 0, yOffm = 0;
      if (c>r) {
        lm*=(r/(float)c);
        xOffm = (mundoSX-r*lm)/2.0;
      }
      if (r>c) {
        hm*=(c/(float)r);
        yOffm = (mundoSY-c*hm)/2.0;
      }

      for (int x = 0; x < r; ++x) {
        for (int y = 0; y < c; ++y) {
          noStroke();
          fill(tiles[grid[x][y].type-1]);
          rect(mundoX+x*lm+xOffm, mundoY+y*hm+yOffm, lm, hm);
        }
      }

      noStroke();
      fill(#4BC7FF);
      rect(mundoX+mundoSX+mundoSX/4.0, mundoY, mundoSX, mundoSY);
      fill(tiles[0]);
      rect(mundoX+mundoSX+mundoSX/4.0, mundoY+mundoSY-mundoSY/5.0, mundoSX+1, mundoSY/5.0);
      image(player, mundoX+mundoSX+mundoSX/2.4, mundoY+mundoY/3.0, mundoSX/1.5, mundoSY/1.5);
      noFill();
      stroke(lerpColor(tiles[1], color(100, 255), .5));
      strokeWeight(3);
      rect(mundoX, mundoY, mundoSX, mundoSY);
      rect(mundoX+mundoSX+mundoSX/4.0, mundoY, mundoSX, mundoSY);
      strokeWeight(1);
    }
  }
}
