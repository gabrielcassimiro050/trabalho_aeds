import processing.sound.*;

tile[][] grid;
int r = 10, c = 10; //Tamanho da grid --- rows e columns (fileiras e colunas)
float l, h; //Tamanho de cada espaço --- length e height (comprimento e altura)
float xOffset, yOffset; //Offset da grid

int timeFrame = 0, frame = floor(10/floor(log(r+c)));

int time = 0; //Tempo desde do início do jogo
int timeGame = 0; //Tempo em jogo
int timeMax = 120; //Tempo máximo de jogo

float escala = .1; //Escala do Noise
float seed; //Seed do Noise
float seedRange = 10000; //Raio da seed

float previewX, previewY; //Posição da preview
float previewTamanhoX, previewTamanhoY; //Tamanho da preview

//Faça o download da library Processing Sound para funcionar
SoundFile musica;
SoundFile[] coleta;
PitchDetector pitch;

PImage[] itemSprites;
PImage[] tileSprites;
PImage playerSprite;
PImage telaDeCarregamento;
PImage placarDeTempo, placarDePontuacao;
PFont pixelFont;

player player;
item item;
menu menuInicial;
menu menuStart;

boolean contando = false;
boolean mapaExpandido = false;
boolean game = false;
boolean loading = true;
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
    if (grid[x][y].tipo==colisao[i]) return false;
  }
  return true;
}

tile[][] criarGrid() {
  tile[][] aux = new tile[r][c];
  for (int x = 0; x < r; ++x) {
    for (int y = 0; y < c; ++y) {
      aux[x][y] = new tile(x, y, random(1)<.9 ? 1 : 2); //Gera Árvores aleatórias
      if (aux[x][y].tipo==1 && random(1)>.5 && mapaExpandido) aux[x][y] = new tile(x, y, (int)map(round(noise(x*escala, y*escala, seed)), 0, 1, 1, 2)); //Gera uma camada de noise
      if (dist(x*l, y*h, round(r/2.0)*l, round(c/2.0)*h)<log(width+height)*10) aux[x][y] = new tile(x, y, 1); //Limpa área ao redor do personagem
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
        if (grid[x][y].tipo == 1) grid[x][y] = new tile(x, y, 2); //Troca Grama por Árvore
        if (grid[x][y].tipo == 4) grid[x][y] = new tile(x, y, 1); //Troca Aux por Grama
      }
      if (dist(x*l, y*h, floor(r/2.0)*l, floor(c/2.0)*h)<log(width+height)*10) grid[x][y] = new tile(x, y, 3); //Adiciona Terra ao redor do centro
      if (grid[x][y].tipo == 1) grid[x][y] = new tile(x, y, round(noise(x*escala, y*escala, seedAux))==0 ? 1 : 3); //Adiciona uma camada de noise de Terra
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
  background(#0C1B3B);
  for (int x = 0; x < r; ++x) {
    for (int y = 0; y < c; ++y) {
      grid[x][y].show();
    }
  }
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
      background(#0C1B3B);
      imageMode(CENTER);
      image(telaDeCarregamento, width/2.0, height/2.0, 320, 160);
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
}

void setup() {
  size(750, 750);
  background(#0C1B3B);

  //Tela de Loading Inicial
  rectMode(CENTER);
  rect(width/2.0, height/2.0, width/4.0, width/4.0);
  rectMode(CORNER);

  l = width/(float)r;
  h = height/(float)c;

  //Define o tamanho dos menus e suas posições
  float mundoTamanhoX = width/1.5, mundoTamanhoY = height/1.5;
  float mundoX = (width-mundoTamanhoX)/2.0, mundoY = (height-mundoTamanhoY)/2.0;

  //Define as proporções da preview
  previewX = (mundoTamanhoX/2.0-mundoTamanhoX/2.5)/2+mundoX;
  previewY = mundoY+(mundoTamanhoY/2.0-mundoTamanhoY/2.5)/2;
  previewTamanhoX = mundoTamanhoX/2.5;
  previewTamanhoY = mundoTamanhoY/2.5;

  //Define o menu Inicial
  menuInicial = new menu(mundoX, mundoY, mundoTamanhoX, mundoTamanhoY, true);
  menuInicial.addBotao(mundoX, mundoY, mundoTamanhoX, mundoTamanhoY/3.0, true, "Game");
  menuInicial.addBotao(mundoX, mundoY+2*mundoTamanhoY/3.0, mundoTamanhoX, mundoTamanhoY/3.0, true, "Sair");

  //Define o menu de Start e seus acessórios se baseando na posição da preview
  menuStart = new menu(mundoX, mundoY, mundoTamanhoX, mundoTamanhoY, false);
  menuStart.addBotao(previewX, previewY, previewX+r*(previewX/previewTamanhoX), previewY+c*(previewY/previewTamanhoY), false, "Mundo"); //Placeholder da preview
  menuStart.addcheckBox(previewX, previewY+5*mundoTamanhoY/12.0, mundoTamanhoX/2.5, mundoTamanhoY/10.0, true, "Expandido");
  menuStart.addBotao(previewX, previewY+31*mundoTamanhoY/60.0, mundoTamanhoX/2.5, mundoTamanhoY/10.0, true, "Random Seed");

  menuStart.addtextBox(previewX, previewY+37*mundoTamanhoY/60.0, mundoTamanhoX/2.5, mundoTamanhoY/10.0, true, "R", "10");
  menuStart.addtextBox(previewX, previewY+43*mundoTamanhoY/60.0, mundoTamanhoX/2.5, mundoTamanhoY/10.0, true, "C", "10");

  menuStart.addBotao(previewX+mundoTamanhoX/2.0, mundoY+31*mundoTamanhoY/40.0-10, mundoTamanhoX/2.5, mundoTamanhoY/10.0, true, "Start");
  menuStart.addBotao(previewX+mundoTamanhoX/2.0, mundoY+7*mundoTamanhoY/8.0, mundoTamanhoX/2.5, mundoTamanhoY/10.0, true, "Voltar");

  //Cria o que servirá para a preview inicial
  geraGrid();

  //Carrega os sons
  musica = new SoundFile(this, "music.mp3");
  coleta = new SoundFile[2];
  for (int i = 0; i < coleta.length; ++i) coleta[i] = new SoundFile(this, "collect_"+i+".mp3");

  //Carrega tela de loading
  telaDeCarregamento = new PImage();
  telaDeCarregamento = loadImage("loading.png");

  //Carrega player
  playerSprite = new PImage();
  playerSprite = loadImage("ladrao.png");

  //Carrega fonte
  pixelFont = createFont("Minecraft.ttf", 20);
  textFont(pixelFont);

  //Toca a musica
  musica.play();
  musica.loop();

  inicio = millis();
  fim = 0;

  loading = true;
}

void draw() {
  if (game) {

    //Carregamento
    if (loading) {
      background(#0C1B3B);
      int x = floor(r/2.0);
      int y = floor(c/2.0);
      player = new player(new PVector(x, y));

      //Carrega os sprites dos itemSprites
      itemSprites = new PImage[10];
      for (int i = 0; i < itemSprites.length; ++i) itemSprites[i] = loadImage("item_"+i+".png");
      item = new item();

      //Carrega os sprites dos tiles
      tileSprites = new PImage[11];
      for (int i = 0; i < tileSprites.length; ++i) tileSprites[i] = loadImage("tile_"+i+".png");


      //Carrega os sprites do time e score
      placarDeTempo = new PImage();
      placarDePontuacao = new PImage();
      placarDeTempo = loadImage("time.png");
      placarDePontuacao = loadImage("score.png");

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
    if (timeFrame%frame==0 && !paused) player.update();

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
      text((timeMax-timeGame)/60+":"+nf((timeMax-timeGame)%60, 2), width/25.0, height/20.0);
      text(nf(player.score, 4), width-width/10.0, height/20.0);
    } else {
      contando = true;
      paused = true;
      fill(255);
      text((timeMax-timeGame)/60+":"+nf((timeMax-timeGame)%60, 2), width/25.0, height-height/20.0);
      text(nf(player.score, 4), width-width/10.0, height-height/20.0);
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

      //Mostra a preview do mapa
      float previewL = previewTamanhoX/(float)r, previewH = previewTamanhoY/(float)c;
      float previewXOffset = 0, previewYOffset = 0;
      
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
          fill(tiles[grid[x][y].tipo-1]);
          rect(previewX+x*previewL+previewXOffset, previewY+y*previewH+previewYOffset, previewL, previewH);
        }
      }

      noStroke();
      fill(#4BC7FF);
      rect(previewX+5*previewTamanhoX/4.0, previewY, previewTamanhoX, previewTamanhoY);
      fill(tiles[0]);
      rect(previewX+5*previewTamanhoX/4.0, previewY+4*previewTamanhoY/5.0, previewTamanhoX+1, previewTamanhoY/5.0);
      image(playerSprite, previewX+3.4*previewTamanhoX/2.4, 4*previewY/3.0, previewTamanhoX/1.5, previewTamanhoY/1.5);
      noFill();
      stroke(lerpColor(tiles[1], color(100, 255), .5));
      strokeWeight(3);
      rect(previewX, previewY, previewTamanhoX, previewTamanhoY);
      rect(previewX+5*previewTamanhoX/4.0, previewY, previewTamanhoX, previewTamanhoY);
      strokeWeight(1);
    }
  }
}
