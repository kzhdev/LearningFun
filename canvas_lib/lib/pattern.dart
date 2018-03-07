part of canvas;

class CanvasPattern extends Group {

  CanvasPattern([Map<String, dynamic> config = const {}]): super(config);

  @override
  Node _createNewInstance(Map<String, dynamic> config) => new CanvasPattern(config);

  @override
  NodeImpl createImpl([bool isReflection = false]) {
    var impl = new PatternImpl(this);
    children.forEach((node) {
      node._impl = node.createImpl(isReflection);
      impl.addChild(node._impl);
    });
    return impl;
  }

  @override
  String get id => getAttribute(ID, '__pattern_${uid}');
}
