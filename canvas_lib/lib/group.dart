part of canvas;

class Group extends ContainerNode {

  Group([Map<String, dynamic> config = const {}]) : super(config);

  @override
  Node _createNewInstance(Map<String, dynamic> config) => new Group(config);

  @override
  NodeImpl createImpl([bool isReflection = false]) {
    var impl = new GroupImpl(this, isReflection);

    if (isReflection) {
      _reflectGroupChildren(children, impl);
    } else {
      children.forEach((node) {
        if (node.impl == null) {
          node._impl = node.createImpl(isReflection);
        }
        impl.addChild(node._impl);
      });
    }
    return impl;
  }

  void _reflectGroupChildren(List<Node> children, GroupImpl impl) {
    children.forEach((child) {
      if (child.reflectable) {
        if (child._reflection == null) {
          child._reflection = child._createReflection();
        }
        impl.addChild(child._reflection);
      }
    });

    // If all children were not reflectable, reflect the firt child.
    // We need some solid shape inside the group
    if (impl.children.isEmpty && children.isNotEmpty) {
      var node = children.first;
      if (node._reflection == null) {
        node._reflection = node._createReflection();
      }
      impl.addChild(node._reflection);
    }
  }

  @override
  bool get reflectable {
    if (getAttribute(REFLECTABLE, true)) {
      var rt = super.reflectable;
      if (!rt) {
        for (int i = 0; i < children.length; i++) {
          if (children[i].reflectable) {
            rt = true;
            break;
          }
        }
      }
      return rt;
    }
    return false;
  }
}
