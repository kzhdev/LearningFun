part of canvas;

class Circle extends Node {

  Circle([Map<String, dynamic> config = const {}]) : super(config);

  @override
  Node _clone(Map<String, dynamic> config) => new Circle(config);

  @override
  void _populateConfig() {
    super._populateConfig();
    var r = attrs[R];
    if (r == null) {
      r = attrs[R] = 0;
    }
    var width = r * 2;
    setAttribute(WIDTH, width);
    setAttribute(HEIGHT, width);
  }

  @override
  NodeImpl createImpl([bool isReflection = false]) =>
    new CircleImpl(this, isReflection);

  @override
  BBox getBBox(bool isAbsolute) {
    var pos = isAbsolute ? this.absolutePosition : this.position;
    return new BBox(
      x: pos.x - r * actualScaleX,
      y: pos.y - r * actualScaleY,
      width: this.actualWidth,
      height: this.actualHeight
    );
  }

  void set r(num value) => setAttribute(R, value);
  num get r => getAttribute(R);
}
