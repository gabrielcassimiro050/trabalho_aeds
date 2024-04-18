class cMenu {
  PVector pos;
  PVector t; //Tamanho
  boolean visivel;
  Lista<cBotao> botoes; //Trocar por lista depois
  Lista<cCheckbox> checkboxes;
  
  cMenu(float x, float y, float tx, float ty, boolean visivel){
    pos = new PVector(x, y);
    t = new PVector(tx, ty);
    botoes = new Lista<cBotao>();
    checkboxes = new Lista<cCheckbox>();
    this.visivel = visivel;
  }
  
  void addBotao(float x, float y, float tx, float ty, boolean visivel, String txt){
      botoes.add(new cBotao(x, y, tx, ty, visivel, txt));
  }
  
  void addCheckbox(float x, float y, float tx, float ty, boolean visivel, String txt){
      checkboxes.add(new cCheckbox(x, y, tx, ty, visivel, txt));
  }
  
  void showMenu(){
    fill(255);
    rect(pos.x, pos.y, t.x, t.y);
    for(int i = 0; i < botoes.size(); ++i){
      botoes.get(i).showBotao();
    }
    for(int i = 0; i < checkboxes.size(); ++i){
      checkboxes.get(i).showCheckbox();
    }
  }
}
