class botao {
  PVector pos;
  PVector tamanho; //Tamanho
  String nome;
  boolean visivel;
  boolean click;

  PImage img;
  boolean hasImage;

  botao(float x, float y, float tx, float ty, boolean visivel, String nome, PImage img) {
    pos = new PVector(x, y);
    tamanho = new PVector(tx, ty);
    this.visivel = visivel;
    this.nome = nome;
    this.img = img;
  }

  void show() {
    if (visivel) {
      if (img!=null) {
        if (click) tint(100, 255);
        else tint(255, 255);
        if (visivel && mouseX>=pos.x && mouseX<=pos.x+tamanho.x && mouseY>=pos.y && mouseY<=pos.y+tamanho.y) tint(150, 255);
        image(img, pos.x, pos.y, tamanho.x, tamanho.y);
        tint(255, 255);
      } else {
        if (click) fill(100);
        else fill(255);
        stroke(1);
        rect(pos.x, pos.y, tamanho.x, tamanho.y);
        fill(0);
        text(nome, pos.x+tamanho.x/2.3, pos.y+30);
      }
    }
  }

  void clicked() {
    if (visivel && mouseX>=pos.x && mouseX<=pos.x+tamanho.x && mouseY>=pos.y && mouseY<=pos.y+tamanho.y) {
      click = true;
    }
  }
}
