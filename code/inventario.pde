class cInventario{
  Lista<Integer> inventario;
  int nItems;
  
  cInventario(){
    inventario = new Lista<Integer>();
    nItems = 0;
  }
  
  void addItem(cItem item){
    //println(item.valor);
    inventario.add(item.valor);
  }
  
  int getItem(int index){
    if(index>=0 && index<inventario.size()) return inventario.get(index);
    else return 0;
  }
  
  void showInventario(){
    for(int i = 0; i < inventario.size(); ++i){
      int s = inventario.size();
      //println("ok");
      image(itens[inventario.get(i)-1], width/s/2+width/s*((i+s)%s), height/s/2+height/s*floor(i/s), width/s, height/s);
      //image(itens[inventario.get(i)-1], width/(r/2)+width/(r/2)*((i+inventario-1)%((r/2)-1)), height/(c/2)+height/(c/2)*floor(i/((c/2)-1)), (r/2), (c/2));
    }
  }
}
