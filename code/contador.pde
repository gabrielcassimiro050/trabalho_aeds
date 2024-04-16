class cContador extends Thread{
  float tempo;
  cContador(float segundos){
    this.tempo = segundos;
  }
  public void run() {
    long inicio = millis();
    long fim = 0;
    contando = true;
    do {
      fim = millis();
    } while (fim-inicio<tempo*1000);
    contando = false;
    contaFinalizada = true;
  }
}
