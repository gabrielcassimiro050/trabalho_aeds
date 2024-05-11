class textBox {
  PVector pos;
  PVector tamanho;
  String nome;
  String txt;
  boolean visivel;
  boolean click;
  PImage img;
  textBox(float x, float y, float tx, float ty, boolean visivel, String nome, String txt, PImage img) {
    pos = new PVector(x, y);
    tamanho = new PVector(tx, ty);
    this.visivel = visivel;
    this.nome = nome;
    this.txt = txt;
    this.img = img;
  }

  void show() {
    if (visivel) {
      if (img!=null) {
        image(img, pos.x, pos.y, tamanho.x, tamanho.y);
      } else {
        if (click) fill(100);
        else fill(255);
        stroke(1);
        rect(pos.x, pos.y, tamanho.x, tamanho.y);
      }
      fill(#82441a);
      textSize(30);
      text(txt, pos.x+tamanho.x/2.3, pos.y+tamanho.y/1.35);
      textSize(20);
    }
  }

  void clicked() {
    if (visivel && mouseX>=pos.x && mouseX<=pos.x+tamanho.x && mouseY>=pos.y && mouseY<=pos.y+tamanho.y) {
      click = true;
    } else {
      click = false;
    }
  }
}
