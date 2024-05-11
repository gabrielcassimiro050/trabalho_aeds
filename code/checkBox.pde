class checkBox {
  PVector pos;
  PVector tamanho; //Tamanho
  String nome;
  boolean visivel;
  boolean click;
  PImage imgUnchecked, imgChecked;

  checkBox(float x, float y, float tx, float ty, boolean visivel, String nome, PImage imgUnchecked, PImage imgChecked) {
    pos = new PVector(x, y);
    tamanho = new PVector(tx, ty);
    this.visivel = visivel;
    this.nome = nome;
    this.imgUnchecked = imgUnchecked;
    this.imgChecked = imgChecked;
  }

  void show() {
    if (visivel) {
      if (imgUnchecked!=null && imgChecked!=null) {
        if(click) image(imgChecked, pos.x, pos.y, tamanho.x, tamanho.y);
        else  image(imgUnchecked, pos.x, pos.y, tamanho.x, tamanho.y);
      } else {
        stroke(1);
        if (click) fill(100);
        else fill(255);
        rect(pos.x, pos.y, tamanho.x, tamanho.y);
        fill(0);
        text(nome, pos.x+tamanho.x/2.3, pos.y+30);
      }
    }
  }

  void clicked() {
    if (visivel && mouseX>=pos.x && mouseX<=pos.x+tamanho.x && mouseY>=pos.y && mouseY<=pos.y+tamanho.y) {
      if (click) click = false;
      else click = true;
    }
  }
}
