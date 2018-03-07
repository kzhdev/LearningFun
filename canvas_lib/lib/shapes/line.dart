part of canvas;

class Line extends Node {
  Line([Map<String, dynamic> config = const {}]): super(config);

  @override
  Node _clone(Map<String, dynamic> config) => new Line(config);

  @override
  NodeImpl createImpl([bool isReflection = false]) =>
    new LineImpl(this, isReflection);

  void set points(List<num> points) {
    assert(points.length >= 4);
    setAttribute(X1, points[0]);
    setAttribute(Y1, points[1]);
    setAttribute(X2, points[2]);
    setAttribute(Y2, points[3]);
  }

  List<num> get points => [getAttribute(X1, 0), getAttribute(Y1, 0),
    getAttribute(X2, 0), getAttribute(Y2, 0)];

  void set x1(num value) => setAttribute(X1, value);
  num get x1 => getAttribute(X1, 0);

  void set y1(num value) => setAttribute(Y1, value);
  num get y1 => getAttribute(Y1, 0);

  void set x2(num value) => setAttribute(X2, value);
  num get x2 => getAttribute(X2, 0);

  void set y2(num value) => setAttribute(Y2, value);
  num get y2 => getAttribute(Y2, 0);

  @override
  BBox getBBox(bool isAbsolute) {
    var pos = isAbsolute ? this.absolutePosition : this.position;
    return new BBox(
      x: pos.x + min(x1, x2) * scaleX,
      y: pos.y + min(y1, y2) * scaleY - (strokeWidth / 2)* scaleY,
      width: (x1 - x2).abs() * scaleX,
      height: ((y1 - y2).abs() + strokeWidth)* scaleY
    );
  }
}
