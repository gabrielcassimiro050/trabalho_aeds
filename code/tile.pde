class cTile {
  PVector pos;
  int type;
  color c;


  cTile(int x, int y, int type) {
    this.pos = new PVector(x, y);
    this.type = type;
    c = tiles[type-1];
  }

  void show() {
    fill(c);
    strokeWeight(5);
    stroke(lerpColor(c, color(0, 255), .5));
    rect(pos.x*l, pos.y*h, l, h);
  }
}
