class cInventario {
  Lista<Integer> inventario;
  int nItems;

  cInventario() {
    inventario = new Lista<Integer>();
    nItems = 0;
  }

  void addItem(cItem item) {
    //println(item.valor);
    inventario.add(item.valor);
  }

  int getItem(int index) {
    if (index>=0 && index<inventario.size()) return inventario.get(index);
    else return 0;
  }

  void showInventario() {
    fill(100, 150);
    rect(0, 0, width, height);
    for (int i = 0; i < inventario.size(); ++i) {
      float sx = width/100;
      float sy = height/100;
      //println(sx+" "+sy);
      //println(sx*((i+sx)%sx));

      image(itens[inventario.get(i)-1], 100*((i+sx)%sx)+50, 100*(floor(i/sx))+50, 100, 100);
      //image(itens[inventario.get(i)-1], width/sx/2+width/sx*((i+sx)%sx), height/sy/2+height/sy*floor(i/sy), width/sx, height/sy);
      //image(itens[inventario.get(i)-1], width/(r/2)+width/(r/2)*((i+inventario-1)%((r/2)-1)), height/(c/2)+height/(c/2)*floor(i/((c/2)-1)), (r/2), (c/2));
    }
  }
}
