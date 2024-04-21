class Lista<T> {
  Object[] objetos;
  int t;

  Lista() {
    objetos = new Object[10];
    t = 0;
  }

  void add(T objeto) {
    if (t==objetos.length) expandir();
    objetos[t] = (T) objeto;
    t++;
  }

  T get(int index) {
    if (index>=0 && index<t) return (T)objetos[index];
    else return null;
  }

  void expandir() {
    Object[] aux = new Object[objetos.length+1];
    System.arraycopy(objetos, 0, aux, 0, objetos.length);
    objetos = aux;
  }

  int size() {
    return t;
  }
}
