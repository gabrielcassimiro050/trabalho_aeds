import processing.sound.*;

tile[][] grid;
int r, c; //Tamanho da grid --- rows e columns (fileiras e colunas)
float l, h; //Tamanho de cada espaço --- length e height (comprimento e altura)
float xOffset, yOffset; //Offset da grid

int tempoFrame, frame;

int tempo; //Tempo desde do início do jogo
int tempoGame; //Tempo em jogo
int tempoMax; //Tempo máximo de jogo

float escala = .1; //Escala do Noise
float seed; //Seed do Noise
float seedRange = 10000; //Raio da seed

float previewX, previewY; //Posição da preview
float previewTamanhoX, previewTamanhoY; //Tamanho da preview

//Faça o download da library Processing Sound para funcionar
SoundFile musica, musicaFinal;
SoundFile[] coleta;
PitchDetector pitch;

PImage[] itemSprites;
PImage[] arvoreSprites;
PImage[] gramaSprites;
PImage[] terraSprites;
PImage play, exitSprite, back, start, seedSprite, bigChecked, bigUnchecked, cSprite, rSprite, reset;
PImage playerSprite;
PImage telaDeCarregamento;
PImage placarDeTempo, placarDePontuacao;
PImage moldura, molduraPontuacao;
PFont pixelFont;

player player;
item item;
menu menuInicial;
menu menuStart;
botao restart, exit;

boolean contando;
boolean mapaExpandido;
boolean game;
boolean loading;
boolean paused;
boolean fim;

long instanteInicial, instanteAnterior;

int colisao[] = {2}; //Árvore

color bg = #060139; //Background
float animacaoInicial = 0;

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
    if (grid[x][y].tipo==colisao[i]) return false;
  }
  return true;
}

tile[][] criarGrid() {
  tile[][] aux = new tile[r][c];
  for (int x = 0; x < r; ++x) {
    for (int y = 0; y < c; ++y) {
      aux[x][y] = new tile(x, y, random(1)<.9 ? random(1)>.8 ? 1 : 0 : 2); //Gera Árvores aleatórias
      if ((aux[x][y].tipo==1 || aux[x][y].tipo==0) && random(1)>.5 && mapaExpandido) aux[x][y] = new tile(x, y, (int)map(round(noise(x*escala, y*escala, seed)), 0, 1, 0, 2)); //Gera uma camada de noise de árvores
      if (dist(x*l+l/2.0, y*h+h/2.0, width/2.0, height/2.0)<=log(width+height)*10) aux[x][y] = new tile(x, y, 1); //Limpa área ao redor do personagem
    }
  }
  return aux;
}


//Do centro do mapa, preenche o mapa com Aux se o espaço for Grama
//Apenas preenche espaços que são alcançáveis
void descobreVazios(int x, int y, int t) {
  //O pior caso nesse cenário seria O(r*c), porém o software não permite muitas recursões, se os valores fossem 250 (o máximo permitido), teriamos 62500 recursões, o que é inviável
  //Então apliquei uma conta que daria um número menor que não é tão eficiente, o que pode gerar aglomerados de árvores em certas ocasiões, devido a incapacidade do algoritmo de alcançar essas áreas
  if (t<(r*2+c*2)*2) {
    ++t;
    for (int i = -1; i <= 1; ++i) {
      if (grid[xC(x+i)][y].tipo != 2 && grid[xC(x+i)][y].tipo != 4) {
        grid[xC(x+i)][y] = new tile(xC(x+i), y, 4); //Adiciona Aux a todo tile de Grama
        descobreVazios(xC(x+i), y, t);  //Chama a função com essa nova posição
      }
    }
    for (int i = -1; i <= 1; ++i) {
      if (grid[x][yC(y+i)].tipo != 2 && grid[x][yC(y+i)].tipo != 4) {
        grid[x][yC(y+i)] = new tile(x, yC(y+i), 4); //Adiciona Aux a todo tile de Grama
        descobreVazios(x, yC(y+i), t);  //Chama a função com essa nova posição
      }
    }
  }
}

//Troca os espaços de Aux com Grama e aqueles de Grama que não foram alcançados por Árvore
//Eliminando os espaços impossíveis de chegar
//Adiciona Terra
void preparaGrid() {
  float seedAux = random(1000);
  for (int x = 0; x < r; ++x) {
    for (int y = 0; y < c; ++y) {
      if (mapaExpandido) {
        if (grid[x][y].tipo == 1 || grid[x][y].tipo == 0) grid[x][y] = new tile(x, y, 2); //Troca Grama por Árvore
        if (grid[x][y].tipo == 4) grid[x][y] = new tile(x, y, random(1)>.8 ? 1 : 0); //Troca Aux por Grama
      }
      if (dist(x*l+l/2.0, y*h+h/2.0, width/2.0, height/2.0)<=log(width+height)*10) grid[x][y] = new tile(x, y, 3); //Adiciona Terra ao redor do centro
      if (grid[x][y].tipo == 1 || grid[x][y].tipo == 0) grid[x][y] = new tile(x, y, round(noise(x*escala, y*escala, seedAux))==0 ? random(1)>.8 ? 1 : 0 : 3); //Adiciona uma camada de noise de Terra
    }
  }
}

//Agrupamento das três funções acima
void geraGrid() {
  grid = criarGrid();
  if (mapaExpandido) {
    descobreVazios(floor(r/2.0), floor(c/2.0), 0);
  }
  preparaGrid();
}

//Mostra a grid
void showGrid() {
  background(bg);
  for (int x = 0; x < r; ++x) {
    for (int y = 0; y < c; ++y) {
      grid[x][y].show();
    }
  }
}

void showPreview() {
  //Mostra a preview do mapa
  float previewL = previewTamanhoX/(float)r, previewH = previewTamanhoY/(float)c;
  float previewXOffset = 0, previewYOffset = 0;
  
  fill(#82441a);
  rect(previewX-previewTamanhoX/30.0, previewY-previewTamanhoY/30.0, previewTamanhoX+previewTamanhoX/15.0, previewTamanhoY+previewTamanhoY/15.0);  
  
  if (c>r) {
    previewL*=(r/(float)c);
    previewXOffset = (previewTamanhoX-r*previewL)/2.0;
  }
  if (r>c) {
    previewH*=(c/(float)r);
    previewYOffset = (previewTamanhoY-c*previewH)/2.0;
  }

  for (int x = 0; x < r; ++x) {
    for (int y = 0; y < c; ++y) {
      noStroke();
      switch(grid[x][y].tipo) {
      case 0:
        fill(#74FF75);
        break;
      case 1:
        fill(#74FF75);
        break;
      case 2:
        fill(#21CB77);
        break;
      case 3:
        fill(#FFFF95);
        break;
      }
      rect(previewX+x*previewL+previewXOffset, previewY+y*previewH+previewYOffset, previewL, previewH);
    }
  }
  
  fill(#82441a);
  rect(previewX+5*previewTamanhoX/4.0-previewTamanhoX/30.0, previewY-previewTamanhoY/30.0, previewTamanhoX+previewTamanhoX/15.0, previewTamanhoY+previewTamanhoY/15.0);
  
  noStroke();
  fill(#4BC7FF);
  rect(previewX+5*previewTamanhoX/4.0, previewY, previewTamanhoX, previewTamanhoY);
  fill(#0EED65);
  rect(previewX+5*previewTamanhoX/4.0, previewY+4*previewTamanhoY/5.0, previewTamanhoX+1, previewTamanhoY/5.0);
  image(playerSprite, previewX+3.4*previewTamanhoX/2.4, 4*previewY/3.0, previewTamanhoX/1.5, previewTamanhoY/1.5);
  noFill();
  strokeWeight(3);
  rect(previewX, previewY, previewTamanhoX, previewTamanhoY);
  rect(previewX+5*previewTamanhoX/4.0, previewY, previewTamanhoX, previewTamanhoY);
  strokeWeight(1);
}
//-------------------------------------------------------------------------------------------------------


//Valor do item
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
      player.right = true;
      break;
    case 'a':
      player.left = true;
      break;
    case 'w':
      player.up = true;
      break;
    case 's':
      player.down = true;
      break;
    case 'e':
      if (player.abrirInventario) {
        player.abrirInventario = false;
        showGrid();
      } else {
        player.abrirInventario = true;
      }
      break;
    }
    switch(keyCode) {
    case RIGHT:
      player.right = true;
      break;
    case LEFT:
      player.left = true;
      break;
    case UP:
      player.up = true;
      break;
    case DOWN:
      player.down = true;
      break;
    }
  }
}

void keyReleased() {
  for (int i = 0; i < menuStart.textBoxes.size(); ++i) {
    textBox textBox = menuStart.textBoxes.get(i);
    if (textBox.click) {
      //Apaga a string
      if (keyCode==BACKSPACE) textBox.txt = new String();

      //Adiciona o caractere à string
      if (textBox.txt!=null && Character.isDigit(key)) {
        if (!textBox.txt.equals("0")) {
          textBox.txt = textBox.txt.concat(Character.toString(key));
        } else {
          textBox.txt = Character.toString(key);
        }
      } else if (keyCode!=ENTER) {
        textBox.txt = "0";
      }

      //Valida a string, adiciona aos valores de r e c e calcula as novas dimensões de cada espaço no mapa
      if (keyCode==ENTER) {
        if (textBox.txt=="0") textBox.txt = "1";
        textBox.txt = Integer.valueOf(textBox.txt)<=250 ? textBox.txt : "250";
        if (textBox.nome.equals("R")) r = Integer.valueOf(textBox.txt);
        if (textBox.nome.equals("C")) c = Integer.valueOf(textBox.txt);
        frame = floor(10/floor(log(r+c)));
        l = width/(float)r;
        h = height/(float)c;
        geraGrid();
      }
    }
  }
  if (game) {
    switch(key) {
    case 'd':
      player.right = false;
      break;
    case 'a':
      player.left = false;
      break;
    case 'w':
      player.up = false;
      break;
    case 's':
      player.down = false;
      break;
    }
    switch(keyCode) {
    case RIGHT:
      player.right = false;
      break;
    case LEFT:
      player.left = false;
      break;
    case UP:
      player.up = false;
      break;
    case DOWN:
      player.down = false;
      break;
    }
  }
}

void mousePressed() {
  if (menuInicial.visivel) {
    for (int i = 0; i < menuInicial.botoes.size(); ++i) {
      botao botao = menuInicial.botoes.get(i);
      botao.clicked();
    }
  }
  if (menuStart.visivel) {
    for (int i = 0; i < menuStart.botoes.size(); ++i) {
      botao botao = menuStart.botoes.get(i);
      botao.clicked();
    }
    for (int i = 0; i < menuStart.checkBoxes.size(); ++i) {
      checkBox checkBox = menuStart.checkBoxes.get(i);
      checkBox.clicked();
    }
    for (int i = 0; i < menuStart.textBoxes.size(); ++i) {
      textBox textBox = menuStart.textBoxes.get(i);
      textBox.clicked();
      if (textBox.click) textBox.txt = "0";
    }
  }

  restart.clicked();
}

void mouseReleased() {

  //Menu Inicial--------------------------------
  if (menuInicial.visivel) {
    botao game = menuInicial.getBotao("Game");
    botao sair = menuInicial.getBotao("Sair");

    if (game.click) {
      menuInicial.visivel = false;
      menuStart.visivel = true;
      game.click = false;
      background(bg);
    }
    if (sair.click) {
      exit();
    }
  }
  //--------------------------------------------

  //Menu Start----------------------------------
  if (menuStart.visivel) {
    botao start = menuStart.getBotao("Start");
    botao voltar = menuStart.getBotao("Voltar");
    botao randomSeed = menuStart.getBotao("Random Seed");
    checkBox expandido = menuStart.getcheckBox("Expandido");

    if (start.click) {
      menuStart.visivel = false;
      background(bg);
      imageMode(CENTER);
      image(telaDeCarregamento, width/2.0, height/2.0, 320, 160);
      game = true;
      start.click = false;
    }

    if (voltar.click) {
      menuStart.visivel = false;
      menuInicial.visivel = true;
      voltar.click = false;
      background(bg);
    }

    if (expandido.click) {
      if (!mapaExpandido) {
        mapaExpandido = true;
        geraGrid();
      }
    } else {
      if (mapaExpandido) {
        mapaExpandido = false;
        geraGrid();
      }
    }

    if (randomSeed.click) {
      seed = random(seedRange);
      geraGrid();
      randomSeed.click = false;
    }
  }
  //--------------------------------------------

  if (restart.click) {
    background(bg);
    imageMode(CORNER);
    setup();
    restart.click = false;
  }
  
  if(exit.click){
    exit();
  }
}

void setup() {
  size(750, 750);
  background(bg);
  
  r = 10;
  c = 10;
  
  tempoFrame = 0;
  frame = floor(10/floor(log(r+c)));
  
  contando = false;
  mapaExpandido = false;
  game = false;
  loading = true;
  paused = false;
  fim = false;

  tempo = 0;
  tempoGame = 0;
  tempoMax = 1;

  //Tela de Loading Inicial
  noStroke();
  rectMode(CENTER);
  rect(width/2.0, height/2.0, width/4.0, width/4.0);
  rectMode(CORNER);

  //Carrega os sprites dos botões
  play = new PImage();
  play = loadImage("play.png");
  exitSprite = new PImage();
  exitSprite = loadImage("exit.png");
  back = new PImage();
  back = loadImage("back.png");
  start = new PImage();
  start = loadImage("start.png");
  seedSprite = new PImage();
  seedSprite = loadImage("seed.png");
  bigUnchecked = loadImage("big_unchecked.png");
  bigChecked = loadImage("big_checked.png");
  cSprite = new PImage();
  cSprite = loadImage("c.png");
  rSprite = new PImage();
  rSprite = loadImage("r.png");
  reset = new PImage();
  reset = loadImage("reset.png");

  l = width/(float)r;
  h = height/(float)c;

  //Define o tamanho dos menus e suas posições
  float mundoTamanhoX = width/1.5, mundoTamanhoY = height/1.5;
  float mundoX = (width-mundoTamanhoX)/2.0, mundoY = (height-mundoTamanhoY)/2.0;

  //Define as proporções da preview
  previewX = (mundoTamanhoX/2.0-mundoTamanhoX/2.5)/2+mundoX;
  previewY = mundoY*.9+(mundoTamanhoY/2.0-mundoTamanhoY/2.5)/2;
  previewTamanhoX = mundoTamanhoX/2.5;
  previewTamanhoY = mundoTamanhoY/2.5;

  //Define o menu Inicial
  float inicialX = (width-width/2.0)/2.0, inicialY = height/1.7;
  menuInicial = new menu(inicialX, inicialY, width/4.0, height/4.0, true);
  menuInicial.addBotao(inicialX, inicialY, width/2.0, height/8.0, true, "Game", play);
  menuInicial.addBotao(inicialX, inicialY+height/6.0, width/2.0, height/8.0, true, "Sair", exitSprite);

  //Define o menu de Start e seus acessórios se baseando na posição da preview
  menuStart = new menu(mundoX, mundoY, mundoTamanhoX, mundoTamanhoY, false);
  menuStart.addBotao(previewX, previewY, previewX+r*(previewX/previewTamanhoX), previewY+c*(previewY/previewTamanhoY), false, "Mundo", null); //Placeholder da preview
  menuStart.addcheckBox(previewX, previewY+5*mundoTamanhoY/12.0+mundoTamanhoY/45.0, mundoTamanhoX/2.5, mundoTamanhoY/10.0, true, "Expandido", bigUnchecked, bigChecked);
  menuStart.addBotao(previewX, previewY+31*mundoTamanhoY/60.0+mundoTamanhoY/150.0+mundoTamanhoY/45.0, mundoTamanhoX/2.5, mundoTamanhoY/10.0, true, "Random Seed", seedSprite);

  menuStart.addtextBox(previewX, previewY+37*mundoTamanhoY/60.0+mundoTamanhoY/150.0*2+mundoTamanhoY/45.0, mundoTamanhoX/2.5, mundoTamanhoY/10.0, true, "R", "10", rSprite);
  menuStart.addtextBox(previewX, previewY+43*mundoTamanhoY/60.0+mundoTamanhoY/150.0*3+mundoTamanhoY/45.0, mundoTamanhoX/2.5, mundoTamanhoY/10.0, true, "C", "10", cSprite);

  menuStart.addBotao(previewX+mundoTamanhoX/2.0, mundoY+31*mundoTamanhoY/40.0-mundoTamanhoY/10.7, mundoTamanhoX/2.5, mundoTamanhoY/10.0, true, "Start", start);
  menuStart.addBotao(previewX+mundoTamanhoX/2.0, mundoY+7*mundoTamanhoY/8.0-mundoTamanhoY/11.2, mundoTamanhoX/2.5, mundoTamanhoY/10.0, true, "Voltar", back);

  restart = new botao((width-width/1.5)/2.4+width/1.5/2.0, (height-height/1.5)/4.0+height/2.0, width/1.5/2.0, height/1.5/8.0, false, "restart", reset);
  exit = new botao((width-width/1.5)/2.4+width/1.5/2.0, (height-height/1.5)/4.0+height/2.0+height/1.5/7.0, width/1.5/2.0, height/1.5/8.0, false, "exit", exitSprite);  
  
  //Cria o que servirá para a preview inicial
  geraGrid();

  //Carrega os sons
  musica = new SoundFile(this, "music.mp3");
  musicaFinal = new SoundFile(this, "end_music.mp3");
  coleta = new SoundFile[2];
  for (int i = 0; i < coleta.length; ++i) coleta[i] = new SoundFile(this, "collect_"+i+".mp3");

  //Carrega tela de loading
  telaDeCarregamento = new PImage();
  telaDeCarregamento = loadImage("loading.png");

  //Carrega player
  playerSprite = new PImage();
  playerSprite = loadImage("ladrao.png");

  //Carrega os sprites dos itemSprites
  itemSprites = new PImage[10];
  for (int i = 0; i < itemSprites.length; ++i) itemSprites[i] = loadImage("item_"+i+".png");

  //Carrega fonte
  pixelFont = createFont("Minecraft.ttf", 20);
  textFont(pixelFont);

  //Toca a musica
  musica.play();
  musica.loop();

  instanteInicial = millis();
  instanteAnterior = 0;
  loading = true;
}

void draw() {
  if (game) {

    //Carregamento
    if (loading) {
      background(bg);
      int x = floor(r/2.0);
      int y = floor(c/2.0);
      player = new player(new PVector(x, y));
      item = new item();

      //Carrega os sprites dos tiles
      arvoreSprites = new PImage[11];
      for (int i = 0; i < arvoreSprites.length; ++i) arvoreSprites[i] = loadImage("tree_"+i+".png");
      gramaSprites = new PImage[2];
      for (int i = 0; i < gramaSprites.length; ++i) gramaSprites[i] = loadImage("grass_"+i+".png");
      terraSprites = new PImage[1];
      for (int i = 0; i < terraSprites.length; ++i) terraSprites[i] = loadImage("dirt_"+i+".png");


      //Carrega os sprites do tempo e score
      placarDeTempo = new PImage();
      placarDePontuacao = new PImage();
      moldura = new PImage();
      molduraPontuacao = new PImage();
      placarDeTempo = loadImage("time.png");
      placarDePontuacao = loadImage("score.png");
      moldura = loadImage("frame.png");
      molduraPontuacao = loadImage("frameScore.png");

      //Define e coloca input no PitchDetector (Detecta a nota fundamental)
      //Serve para que o personagem se balançe no ritmo da música
      pitch = new PitchDetector(this, 0);
      pitch.input(musica);

      //Calcula o offset do mapa
      //Evita que haja distorções no mapa
      if (c>r) {
        l*=(r/(float)c);
        xOffset = (width-r*l)/2.0;
      }
      if (r>c) {
        h*=(c/(float)r);
        yOffset = (height-c*h)/2.0;
      }

      showGrid();
      loading = false;
    }


    //Define a velocidade do player, aplicando um delay ao input de movimento
    if (tempoFrame%frame==0 && !paused) player.update();

    //Gera o item enquanto não estiver pausado e 10 segundos passaram
    if (tempoGame%10 == 0 && !contando) {
      item.zeraItem();
      item.geraItem();
    }

    //Conta o tempo de jogo enquanto não estiver pausado e 1 segundo passar
    if (tempo%1 == 0 && !contando && !paused) {
      tempoGame++;
    }

    //Checa se o jogo ainda não acabou
    if (tempoMax-tempoGame<=0 && contando) {
      player.animacao = 0;
      game = false;
    }

    //Mostra o player e o item
    if (!player.abrirInventario) item.show();
    player.show();

    //Checa se o inventário está aberto e pausa o jogo
    if (!player.abrirInventario) {
      paused = false;
      contando = false;
      image(placarDeTempo, width*.08, height*.04, width*.16, height*.08);
      image(placarDePontuacao, width-width*.08, height*.04, width*.16, height*.08);
      fill(#82441a);
      text((tempoMax-tempoGame)/60+":"+nf((tempoMax-tempoGame)%60, 2), width/25.0, height/20.0);
      text(nf(player.score, 4), width-width/10.0, height/20.0);
    } else {
      contando = true;
      paused = true;
      fill(255);
      text((tempoMax-tempoGame)/60+":"+nf((tempoMax-tempoGame)%60, 2), width/25.0, height-height/20.0);
      text(nf(player.score, 4), width-width/10.0, height-height/20.0);
    }

    //Conta os segundos
    long instanteAtual = millis();
    if (segundos(instanteInicial, instanteAtual)-segundos(instanteInicial, instanteAnterior)==1) {
      ++tempo;
      contando = false;
    } else {
      contando = true;
    }
    instanteAnterior = millis();

    ++tempoFrame;
  } else {
    if (menuInicial.visivel) {
      background(bg);
      menuInicial.show();
      imageMode(CENTER);
      pushMatrix();
      translate(width/2.5, height/2.5);
      rotate(radians(10));
      image(playerSprite, 0, sin(animacaoInicial)*5, width/3.5, height/3.5);
      image(itemSprites[2], width/3, -height/5+sin(animacaoInicial-10)*5, width/10, height/10);
      image(itemSprites[8], width/8, -height/4+sin(animacaoInicial-20)*5, width/7, height/7);
      popMatrix();
      imageMode(CORNER);
      animacaoInicial += .2;
    }

    if (menuStart.visivel) {
      background(bg);
      rectMode(CENTER);
      fill(#82441a);
      rect(width/2, height/2, width/1.4, height/1.4);
      fill(#ffb583);
      rect(width/2, height/2, width/1.5, height/1.5);
      rectMode(CORNER);
      menuStart.show();
      showPreview();
    }

    if (tempoGame>=tempoMax) {
      musica.stop();
      playerSprite = loadImage("ladrao_cansado.png");
      player.inventario.sortInventario();
      //player.abrirInventario = true;
      player.show();

      if (fim) {
        rectMode(CENTER);
        fill(#82441a);
        rect(width/2.0, height/2.0, width/1.35, height/1.35, 25);
        fill(#ffb583);
        rect(width/2.0, height/2.0, width/1.5, height/1.5);
        rectMode(CORNER);

        int[] aux = player.inventario.retornaQuantidade();
        float x = (width-width/1.5)/2.0;
        float y = (height-height/1.5)/2.0;

        for (int i = 0; i < 10; ++i) {
          image(moldura, x+(width/10.0+x/10.0)*((i+2)%2)+x/2.0, x+(width/10.0+x/10.0)*(floor(i/2))+y/2.0, width/10.0, height/10.0);
        }

        for (int i = itemSprites.length-1; i >= 0; --i) {
          image(itemSprites[i], x+(width/10.0+x/10.0)*((i+2)%2)+x/2.0, x+(width/10.0+x/10.0)*(floor(i/2))+y/2.0, width/10.0, height/10.0);
          fill(255);
          textSize(21);
          text(aux[i]+"x", x+(width/10.0+x/10.0)*((i+2)%2)+x/2.0+width/25.0, x+(width/10.0+x/10.0)*(floor(i/2))+y/2.0+height/22.0, width/10.0, height/10.0);
          textSize(20);
        }

        fill(#e6955e);
        image(molduraPontuacao, (width-width/1.5)/2.0+width/1.5/1.4, (height-height/1.5)/4.0+height/5.0, width/1.5/2.0, height/1.5/4.0);
        fill(255);
        textSize(45);
        text(nf(player.score, 4), (width-width/1.5)/4.0+width/1.5/1.35, (height-height/1.5)/4.0+height/4.5);

        imageMode(CORNER);
        restart.visivel = true;
        exit.visivel = true;
        restart.show();
        exit.show();
        imageMode(CENTER);
      }
    }
  }
}
