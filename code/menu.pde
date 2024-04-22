class cMenu {
  PVector pos;
  PVector t; //Tamanho
  boolean visivel;
  Lista<cBotao> botoes; //Trocar por lista depois
  Lista<cCheckbox> checkboxes;
  Lista<cTextbox> textboxes;
  
  cMenu(float x, float y, float tx, float ty, boolean visivel){
    pos = new PVector(x, y);
    t = new PVector(tx, ty);
    botoes = new Lista<cBotao>();
    checkboxes = new Lista<cCheckbox>();
    textboxes = new Lista<cTextbox>();
    this.visivel = visivel;
  }
  
  void addBotao(float x, float y, float tx, float ty, boolean visivel, String nome){
      botoes.add(new cBotao(x, y, tx, ty, visivel, nome));
  }
  
  void addCheckbox(float x, float y, float tx, float ty, boolean visivel, String nome){
      checkboxes.add(new cCheckbox(x, y, tx, ty, visivel, nome));
  }
  
  void addTextbox(float x, float y, float tx, float ty, boolean visivel, String nome, String txt){
      textboxes.add(new cTextbox(x, y, tx, ty, visivel, nome, txt));
  }
  
  cBotao getBotao(String botao){
    for(int i = 0; i < botoes.size(); ++i){
      if(botao.equals(botoes.get(i).nome)) return botoes.get(i);
    }
    return null;
  }
  
  cCheckbox getCheckbox(String checkbox){
    for(int i = 0; i < checkboxes.size(); ++i){
      if(checkbox.equals(checkboxes.get(i).nome)) return checkboxes.get(i);
    }
    return null;
  }
  
  cTextbox getTextbox(String textbox){
    for(int i = 0; i < textboxes.size(); ++i){
      if(textbox.equals(textboxes.get(i).nome)) return textboxes.get(i);
    }
    return null;
  }
  
  void show(){
    fill(255);
    rect(pos.x, pos.y, t.x, t.y);
    for(int i = 0; i < botoes.size(); ++i){
      botoes.get(i).show();
    }
    for(int i = 0; i < checkboxes.size(); ++i){
      checkboxes.get(i).show();
    }
    for(int i = 0; i < textboxes.size(); ++i){
      textboxes.get(i).show();
    }
  }
}
