part of canvas;

class BBox {
  num x;
  num y;
  num width;
  num height;
  num left;
  num right;
  num top;
  num bottom;

  BBox({x:0, y:0, width:0, height:0}) {
    this.x = this.left = x;
    this.y = this.top = y;
    this.width = width;
    this.height = height;
    this.right = x + width;
    this.bottom = y + height;
  }
}