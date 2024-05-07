class Lista<T> { //Aqui é criado uma classe que recebe um tipo genérico
  Object[] objetos;
  int t;

  Lista() {
    objetos = new Object[10];  // Dentro do construtor da lista criamos um vetor inicial com 10 posições
    t = 0;  //Ao iniciar a lista, ela começa sem nenhum elemento salvo logo, seu conteudo é 0
  }

  void add(T objeto) {
    if (t==objetos.length){
      expandir();// Antes de adicionar um objeto, ocorre a verificação se a lista possui espaço suficiente para armazená-lo
    }
    objetos[t] = (T) objeto;// Aqui temos a adição do objeto recebido em uma posição da lista
    t++;
  }

  T get(int index) {
    if (index>=0 && index<t) {  //Aqui verificamos se o index recebido por parâmetro existe na lista caso exista é retornado o objeto que está na posição pedida
      return (T)objetos[index];
    }
    else return null;  //Caso o index seja inválido, retorna null
  }

  void expandir() {
    Object[] aux = new Object[objetos.length+1];  // Aqui é criado um vetor de objetos auxiliar com o tamanho = tamanho + 1

//public static void arraycopy(Object origem, int posiçãoOrigem, Object destino, int posiçãoDestino, int comprimento);

    System.arraycopy(objetos, 0, aux, 0, objetos.length);  // Aqui é copiado os elementos anteriores para o vetor auxiliar
    objetos = aux;//  vetor objetos é atualizado para apontar para o vetor aux. Ou seja, o vetor objetos agora referencia o novo vetor expandido
  }

  int size() {
    return t;
  }
}
