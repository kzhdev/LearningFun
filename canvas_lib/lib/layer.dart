part of canvas;

class Layer extends Group {
  Canvas _canvas;

  Layer([Map<String, dynamic> config = const {}]) : super(config) {
    _impl = createImpl();
  }

  @override
  Node _createNewInstance(Map<String, dynamic> config) => new Layer(config);

  @override
  NodeImpl createImpl([bool isReflection = false]) => new LayerImpl(this, isReflection);

  @override
  void remove() {
    if (_canvas != null) {
      if (_impl != null) {
        _impl.remove();
      }

      if (_reflection != null) {
        children.forEach((child) {
          if (child._reflection != null) {
            child._reflection.remove();
          }
        });
      }

      var sUid = uid.toString();
      _canvas
        ..off('widthChanged', sUid)
        ..off('heightChanged', sUid);
      _canvas.removeChild(this);
    }
  }

  @override
  Layer get layer => this;

  @override
  LayerImpl get impl => _impl;

  void set canvas(Canvas value) {
    _canvas = value;
    _transformMatrix = _canvas._transformMatrix;

    var sUid = uid.toString();
    _canvas
      ..on('widthChanged', (newValue) {
      width = newValue;
    }, sUid)
      ..on('heightChanged', (newValue) {
      height = newValue;
    }, sUid);
    fire('canvasSet');
  }

  Canvas get canvas => _canvas;

  @override
  num get width => getAttribute(WIDTH);

  @override
  num get height => getAttribute(HEIGHT);

  void set background(String value) => setAttribute(BACKGROUND, value);
  String get background => getAttribute(BACKGROUND);
}
