class Lista<T> { //Aqui é criado uma classe que recebe um tipo genérico
  Object[] objetos;
  int tamanho;

  Lista() {
    objetos = new Object[10];  // Dentro do construtor da lista criamos um vetor inicial com 10 posições
    tamanho = 0;  //Ao iniciar a lista, ela começa sem nenhum elemento salvo logo, seu conteudo é 0
  }

  void add(T objeto) {
    if (tamanho==objetos.length){
      expandir();// Antes de adicionar um objeto, ocorre a verificação se a lista possui espaço suficiente para armazená-lo
    }
    objetos[tamanho] = (T) objeto;// Aqui temos a adição do objeto recebido em uma posição da lista
    tamanho++;
  }
  
  void set(int index, T valor){
    if (index>=0 && index<tamanho) objetos[index] = valor;
  }
  
  T get(int index) {
    if (index>=0 && index<tamanho) {  //Aqui verificamos se o index recebido por parâmetro existe na lista caso exista é retornado o objeto que está na posição pedida
      return (T)objetos[index];
    }
    else return null;  //Caso o index seja inválido, retorna null
  }
  
  void swap(int id1, int id2){
    T aux = get(id1);
    set(id1, get(id2));
    set(id2, aux);
  }
  
  void expandir() {
    Object[] aux = new Object[tamanho+1];  // Aqui é criado um vetor de objetos auxiliar com o tamanho = tamanho + 1
    System.arraycopy(objetos, 0, aux, 0, tamanho);  // Aqui é copiado os elementos anteriores para o vetor auxiliar
    objetos = aux;//  vetor objetos é atualizado para apontar para o vetor aux. Ou seja, o vetor objetos agora referencia o novo vetor expandido
  }

  int size() {
    return tamanho;
  }
}
