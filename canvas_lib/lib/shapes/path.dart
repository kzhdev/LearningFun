part of canvas;

class Path extends Node {

  PathImpl _svgImpl;
  var _bbox = null;

  Path([Map<String, dynamic> config = const {}]) : super(config) {
    _svgImpl = createImpl(false);
    this.on('dChanged', () => _bbox = null);
  }

  @override
  Node _clone(Map<String, dynamic> config) => new Path(config);

  @override
  NodeImpl createImpl([bool isReflection = false]) {
    if (isReflection) {
      return new PathImpl(this, isReflection);
    } else if (_svgImpl == null) {
      _svgImpl = new PathImpl(this, isReflection);
    }
    return _svgImpl;
  }

  @override
  BBox getBBox(bool isAbsolute) {
    if (this.canvas != null) {
      // TODO: improve it.

      var reflection = this.reflection;
      if (reflection == null) {
        if (_bbox != null) {
          // TODO: should recalculate?
          return _bbox;
        }

        reflection = this._createReflection();
        canvas._reflectionLayer.impl.addChild(reflection);
      }

      var bbx = reflection.getBBox(isAbsolute);
      _bbox = new BBox(
        x: bbx.x,
        y: bbx.y,
        width: bbx.width * actualScaleX,
        height: bbx.height * actualScaleY
      );

      if (this.reflection == null) {
        reflection.remove();
      }
      return _bbox;
    }
    var pos = isAbsolute ? this.absolutePosition : this.position;
    return new BBox(
      x: pos.x,
      y: pos.y,
      width: getAttribute(WIDTH, 0) * actualScaleX,
      height: getAttribute(HEIGHT, 0) * actualScaleY
    );
  }

  void set d(String value) => setAttribute(D, value);
  String get d => getAttribute(D);

  @override
  num get width {
    var bbox = getBBox(true);
    return bbox.width;
  }

  @override
  num get height {
    var bbox = getBBox(true);
    return bbox.height;
  }
}
