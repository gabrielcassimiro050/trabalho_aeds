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

  int[] retornaQuantidade() {
    int[] aux = new int[10];
    for(int i = 0; i < 10; ++i){
      for(int j = 0; j<inventario.size(); ++j){
        if(inventario.get(j)==(i+1)) aux[i]++;
      }
    }
    return aux;
  }

  void sortInventario() {
    for (int i = inventario.size(); i >= 0; --i) {
      for (int j = 0; j < i-1; ++j) {
        if (inventario.get(j)>inventario.get(j+1)) {
          inventario.swap(j, j+1);
        }
      }
    }
  }

  void show() {
    fill(100, 10);
    noStroke();
    rect(0, 0, width, height);
    float n = 6;
    float x = width/n;
    float y = height/n;
    for (int i = 0; i < inventario.size(); ++i) {
      image(itemSprites[inventario.get(i)-1], x*((i+n)%n)+x/2.0, x*(floor(i/n))+y/2.0, y, y);
    }
  }
}
