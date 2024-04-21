class cBotao {
  PVector pos;
  PVector t; //Tamanho
  String txt;
  boolean visivel;
  boolean click;

  cBotao(float x, float y, float tx, float ty, boolean visivel, String txt) {
    pos = new PVector(x, y);
    t = new PVector(tx, ty);
    this.visivel = visivel;
    this.txt = txt;
  }

  void showBotao() {
    if (visivel) {
      if (click) fill(100);
      else fill(255);
      stroke(1);
      rect(pos.x, pos.y, t.x, t.y);
      fill(0);
      text(txt, pos.x+t.x/2.3, pos.y+30);
    }
  }

  void clicked() {
    if (visivel && mouseX>=pos.x && mouseX<=pos.x+t.x && mouseY>=pos.y && mouseY<=pos.y+t.y) {
      click = true;
    }
  }
}
