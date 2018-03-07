part of canvas;

abstract class ContainerNodeImpl extends NodeImpl with Container<NodeImpl> {

  ContainerNodeImpl(ContainerNode shell, bool isReflection): super(shell, isReflection);

  @override
  void addChild(NodeImpl child) {
    children.add(child);
    child.parent = this;
    this._implElement.append(child.element);

    if (canvas != null && !_isReflection) {
      _addDefs(child);
    }
  }

  void _addDefs(NodeImpl child) {
    if (canvas != null) {
      child._defs.forEach((def) {
        DefLayer.impl(this.canvas).addDef(def);
      });
    }
  }

  @override
  void removeChild(NodeImpl node) => node.remove();

  @override
  void clearChildren() {
    while (children.isNotEmpty) {
      removeChild(children.first);
    }
  }

  @override
  void insertChild(int index, NodeImpl node) {
    node.parent = this;
    children.insert(index, node);
    this._implElement.nodes.insert(index, node.element);
    _addDefs(node);
  }

  @override
  List get _defs {
    var defs = super._defs;

    for (var child in children) {
      defs.addAll(child._defs);
    }
    return defs;
  }
}
