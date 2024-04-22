class cTile {
  PVector pos;
  int type;



  cTile(int x, int y, int type) {
    this.pos = new PVector(x, y);
    this.type = type;
  }

  void show() {
    int x = (int)pos.x, y = (int)pos.y;
    if (type==2) {
      tint(0, 255, 150, 255);
      noStroke();
      if(grid[x][yC(y-1)].type!=2){ 
        fill(tiles[grid[x][yC(y-1)].type-1]);
      }else{
        fill(tiles[grid[x][yC(y+1)].type-1]);
      }
      rect(x*l+xOff, y*h+yOff, l, h);
      imageMode(CORNER);
      //image(tile[2], x*l, y*h, l, h);

      if (grid[xC(x+1)][y].type!=2 && grid[xC(x-1)][y].type!=2 && grid[x][yC(y+1)].type!=2 && grid[x][yC(y-1)].type!=2) {
        image(tile[3], x*l+xOff, y*h+yOff, l, h);
      }

      

      if ((grid[xC(x+1)][y].type==2 || grid[xC(x-1)][y].type==2) && grid[x][yC(y-1)].type==2) {
        if (grid[xC(x+1)][y].type==2) {
          image(tile[5], x*l+xOff, y*h+yOff, l, h);
        } else {
          pushMatrix();
          translate((x+1)*l+xOff, y*h+yOff);
          scale(-1, 1);
          image(tile[5], 0, 0, l, h);
          popMatrix();
        }
      }
      
      if ((grid[xC(x+1)][y].type==2 || grid[xC(x-1)][y].type==2) && grid[x][yC(y-1)].type!=2 && grid[x][yC(y+1)].type!=2){
        if (grid[xC(x+1)][y].type==2) {
          image(tile[4], x*l+xOff, y*h+yOff, l, h);
        } else {
          pushMatrix();
          translate((x+1)*l+xOff, y*h+yOff);
          scale(-1, 1);
          image(tile[4], 0, 0, l, h);
          popMatrix();
        }
      }
      
      if (grid[xC(x+1)][y].type==2 && grid[xC(x-1)][y].type==2) {
        image(tile[2], x*l+xOff, y*h+yOff, l, h);
      }
      
      if(grid[x][yC(y+1)].type==2){
        if(grid[x][yC(y-1)].type==2 || grid[xC(x-1)][y].type==2 && grid[xC(x+1)][y].type==2){
          image(tile[0], x*l+xOff, y*h+yOff, l, h);
        }
        
        if(grid[xC(x+1)][y].type!=2 && grid[xC(x-1)][y].type!=2){
          image(tile[1], x*l+xOff, y*h+yOff, l, h);
        }
        if (grid[xC(x+1)][y].type!=2 && grid[xC(x-1)][y].type==2) {
          image(tile[6], x*l+xOff, y*h+yOff, l, h);
        } else if(grid[xC(x+1)][y].type==2 && grid[xC(x-1)][y].type!=2){
          pushMatrix();
          translate((x+1)*l+xOff, y*h+yOff);
          scale(-1, 1);
          image(tile[6], 0, 0, l, h);
          popMatrix();
        }
      }
      
      if (grid[x][yC(y+1)].type==2 && grid[x][yC(y-1)].type!=2) {
        if (grid[xC(x+1)][y].type!=2 && grid[xC(x-1)][y].type!=2) {
          image(tile[1], x*l+xOff, y*h+yOff, l, h);
        } else if (grid[xC(x+1)][y].type!=2) {
          image(tile[6], x*l+xOff, y*h+yOff, l, h);
        }
      }

      if (grid[xC(x+1)][y].type!=2 && grid[xC(x-1)][y].type!=2) {
        if (grid[x][yC(y-1)].type==2 && grid[x][yC(y+1)].type!=2) {
          image(tile[7], x*l+xOff, y*h+yOff, l, h);
        }
      }

      tint(255, 255, 255, 255);
    } else {
      fill(tiles[type-1]);
      noStroke();
      //strokeWeight((l+h)/10);
      //stroke(lerpColor(c, color(0, 255), .5));
      rect(x*l+xOff, y*h+yOff, l, h);
    }
  }
}
