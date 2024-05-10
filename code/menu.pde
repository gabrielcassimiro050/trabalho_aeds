class menu {
  PVector pos;
  PVector tamanho; //Tamanho
  boolean visivel;
  Lista<botao> botoes; //Trocar por lista depois
  Lista<checkBox> checkBoxes;
  Lista<textBox> textBoxes;
  
  menu(float x, float y, float tx, float ty, boolean visivel){
    pos = new PVector(x, y);
    tamanho = new PVector(tx, ty);
    botoes = new Lista<botao>();
    checkBoxes = new Lista<checkBox>();
    textBoxes = new Lista<textBox>();
    this.visivel = visivel;
  }
  
  void addBotao(float x, float y, float tx, float ty, boolean visivel, String nome, PImage img, boolean hasImage){
      botoes.add(new botao(x, y, tx, ty, visivel, nome, img, hasImage));
  }
  
  void addcheckBox(float x, float y, float tx, float ty, boolean visivel, String nome){
      checkBoxes.add(new checkBox(x, y, tx, ty, visivel, nome));
  }
  
  void addtextBox(float x, float y, float tx, float ty, boolean visivel, String nome, String txt){
      textBoxes.add(new textBox(x, y, tx, ty, visivel, nome, txt));
  }
  
  botao getBotao(String botao){
    for(int i = 0; i < botoes.size(); ++i){
      if(botao.equals(botoes.get(i).nome)) return botoes.get(i);
    }
    return null;
  }
  
  checkBox getcheckBox(String checkBox){
    for(int i = 0; i < checkBoxes.size(); ++i){
      if(checkBox.equals(checkBoxes.get(i).nome)) return checkBoxes.get(i);
    }
    return null;
  }
  
  textBox gettextBox(String textBox){
    for(int i = 0; i < textBoxes.size(); ++i){
      if(textBox.equals(textBoxes.get(i).nome)) return textBoxes.get(i);
    }
    return null;
  }
  
  void show(){
    noStroke();
    fill(#0C1B3B);
    rect(pos.x, pos.y, tamanho.x, tamanho.y);
    for(int i = 0; i < botoes.size(); ++i){
      botoes.get(i).show();
    }
    for(int i = 0; i < checkBoxes.size(); ++i){
      checkBoxes.get(i).show();
    }
    for(int i = 0; i < textBoxes.size(); ++i){
      textBoxes.get(i).show();
    }
  }
}
