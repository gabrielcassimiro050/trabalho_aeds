class cInventario {
  Lista<Integer> inventario;
  int nItems;

  cInventario() {
    inventario = new Lista<Integer>();
    nItems = 0;
  }

  void addItem(cItem item) {
    inventario.add(item.valor);
  }

  int getItem(int index) {
    if (index>=0 && index<inventario.size()) return inventario.get(index);
    else return 0;
  }

  void showInventario() {
    fill(100, 10);
    noStroke();
    rect(0, 0, width, height);
    for (int i = 0; i < inventario.size(); ++i) {
      float sx = width/100;
      image(itens[inventario.get(i)-1], 100*((i+sx)%sx)+50, 100*(floor(i/sx))+50, 100, 100);
    } 
  }
}
