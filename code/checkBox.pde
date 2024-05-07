class checkBox {
  PVector pos;
  PVector tamanho; //Tamanho
  String nome;
  boolean visivel;
  boolean click;

  checkBox(float x, float y, float tx, float ty, boolean visivel, String nome) {
    pos = new PVector(x, y);
    tamanho = new PVector(tx, ty);
    this.visivel = visivel;
    this.nome = nome;
  }

  void show() {
    if (visivel) {
      stroke(1);
      if (click) fill(100);
      else fill(255);
      rect(pos.x, pos.y, tamanho.x, tamanho.y);
      fill(0);
      text(nome, pos.x+tamanho.x/2.3, pos.y+30);
    }
  }

  void clicked() {
    if (visivel && mouseX>=pos.x && mouseX<=pos.x+tamanho.x && mouseY>=pos.y && mouseY<=pos.y+tamanho.y) {
      if (click) click = false;
      else click = true;
    }
  }
}
