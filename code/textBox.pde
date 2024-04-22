class cTextbox{
  PVector pos;
  PVector t; //Tamanho
  String nome;
  String txt;
  boolean visivel;
  boolean click;

  cTextbox(float x, float y, float tx, float ty, boolean visivel, String nome, String txt) {
    pos = new PVector(x, y);
    t = new PVector(tx, ty);
    this.visivel = visivel;
    this.nome = nome;
    this.txt = txt;
  }

  void show() {
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
    }else{
      click = false;
    }
  }
}
