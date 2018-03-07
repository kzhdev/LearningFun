part of canvas;

class _ReflectionLayer extends Layer {

  _ReflectionLayer([Map<String, dynamic> config = const {}])
    : super(merge(config, { ID: '__reflection_layer'}));

  @override
  NodeImpl createImpl([bool isReflection = false]) => new LayerImpl(this, true);

  @override
  void addChild(Node node) {
    if (node._reflection == null) {
      node._reflection = node._createReflection();
    }

    impl.addChild(node._reflection);
    node.fire('reflection_complete');
  }

  @override
  void insertChild(int index, Node node) {
    if (node._reflection == null) {
      node._reflection = node._createReflection();
    }
    impl.insertChild(index, node._reflection);
    node.fire('reflection_complete');
  }

  void reflectNode(Node node) {
    if (node.layer == null) {
      return;
    }

    if (!node.reflectable) {
      return;
    }

    var node_layer = node.layer;
    var layerIndex = canvas.children.indexOf(node_layer);
    bool reflectionAdded = false;

    for (int i = layerIndex + 1, len = _canvas.children.length;
    i < len; i++) {

      Layer layer = _canvas.children[i];
      var firstRefNode = layer.firstReflectableNode(excludeChild: true);
      if (firstRefNode != null && firstRefNode._reflection != null) {
        var index = impl.children.indexOf(firstRefNode._reflection);
        if (index != -1) {
          insertChild(index, node);
          reflectionAdded = true;
          break;
        }
      }
    }

    if (reflectionAdded == false) {
      addChild(node);
    }
  }
}
