class cCheckbox{
   PVector pos;
  PVector t; //Tamanho
  String txt;
  boolean visible;
  boolean click;

  cCheckbox(float x, float y, float tx, float ty, boolean visible, String txt) {
    pos = new PVector(x, y);
    t = new PVector(tx, ty);
    this.visible = visible;
    this.txt = txt;
  }

  void showCheckbox() {
    if(click) fill(100);
    else fill(255);
    rect(pos.x, pos.y, t.x, t.y);
    fill(0);
    text(txt, pos.x+t.x/2.3, pos.y+30);
  }
  
  void clicked() {
    if (mouseX>=pos.x && mouseX<=pos.x+t.x && mouseY>=pos.y && mouseY<=pos.y+t.y) {
      if(click) click = false;
      else click = true;   
    }
  }
}
