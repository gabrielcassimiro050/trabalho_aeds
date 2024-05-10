class inventario {
  Lista<Integer> inventario;

  inventario() {
    inventario = new Lista<Integer>();
  }

  void addItem(item item) {
    inventario.add(item.valor);
  }

  int getItem(int index) {
    return inventario.get(index);
  }
  
  void sortInventario(){
    for(int i = inventario.size(); i >= 0; --i){
      for(int j = 0; j < i-1; ++j){
        if(inventario.get(j)<inventario.get(j+1)){
          inventario.swap(j, j+1);
        }
      }
    }
  }
  
  void show() {
    fill(100, 10);
    noStroke();
    rect(0, 0, width, height);
    for (int i = 0; i < inventario.size(); ++i) {
      float sx = width/100;
      image(itemSprites[inventario.get(i)-1], 100*((i+sx)%sx)+50, 100*(floor(i/sx))+50, 100, 100);
    } 
  }
}
