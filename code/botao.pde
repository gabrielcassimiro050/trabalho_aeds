class cBotao {
  PVector pos;
  PVector t; //Tamanho
  String nome;
  boolean visivel;
  boolean click;

  cBotao(float x, float y, float tx, float ty, boolean visivel, String nome) {
    pos = new PVector(x, y);
    t = new PVector(tx, ty);
    this.visivel = visivel;
    this.nome = nome;
  }

  void show() {
    if (visivel) {
      if (click) fill(100);
      else fill(255);
      stroke(1);
      rect(pos.x, pos.y, t.x, t.y);
      fill(0);
      text(nome, pos.x+t.x/2.3, pos.y+30);
    }
  }

  void clicked() {
    if (visivel && mouseX>=pos.x && mouseX<=pos.x+t.x && mouseY>=pos.y && mouseY<=pos.y+t.y) {
      click = true;
    }
  }
}
