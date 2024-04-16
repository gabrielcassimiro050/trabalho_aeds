class cPlayer{
  PVector pos;
  boolean right, left, up, down; //Direções (Direita, Esquerda, Cima, Baixo)
  
  cPlayer(PVector pos){
    this.pos = pos;
  }
  
  void update(){
    int x = (int)pos.x; 
    int y =(int) pos.y;
    int dx = 0, dy = 0;
    
    if(x+vel<r && right && grid[x+vel][y] == 1) dx = vel;
    if(x-vel>=0 && left && grid[x-vel][y] == 1) dx = -vel;
    if(y+vel<c && down && grid[x][y+vel] == 1) dy = vel;
    if(y-vel>=0 && up && grid[x][y-vel] == 1) dy = -vel;
    
    if(grid[x+dx][y+dy] != 2 && x+dx<r && x+dx>=0 && y+dy<c && y+dy>=0) pos = new PVector(x+dx, y+dy);
    if(pos.x == item.pos.x && pos.y == item.pos.y) item.zeraItem();
    //println(pos+" "+item.pos);
  }
  
  void showPlayer(){
    fill(0);
    rect(pos.x*l, pos.y*h, l, h);
  }
}
