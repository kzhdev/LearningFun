part of canvas;

class DefLayerImpl {

  static const String _refCount = 'refCount';

  final Layer _layer = new Layer({ID: '__def_layer'});
  final svg.DefsElement _defsEl = new svg.DefsElement();
  final Map _suspendedDefs = {};

  LayerImpl _impl;
  svg.SvgElement _element;

  DefLayerImpl() {
    _impl = _layer.impl;
    _element = _impl.element;
    _impl.element.append(_defsEl);
  }

  void addDef(Node defNode) {
    var defImplEl = _element.querySelector('#${defNode.id}');
    if (defImplEl == null) {
      NodeImpl defImpl = defNode.createImpl();
      defImplEl = defImpl.element;
      _defsEl.append(defImpl.element);
      defImplEl.dataset[_refCount] = '1';
    } else {
      defImplEl.dataset[_refCount] = '${int.parse(defImplEl.dataset[_refCount]) + 1}';
    }
    defNode.fire(defAdded);
  }

  void removeDef(Node defNode) {
    svg.SvgElement defImplEl = _element.querySelector('#${defNode.id}');
    if (defImplEl != null) {
      num refCnt = int.parse(defImplEl.dataset[_refCount]);
      if (--refCnt > 0) {
        defImplEl.dataset[_refCount] = refCnt.toString();
      } else {
        defImplEl.remove();
      }
    }
  }

  void suspendDef(Node defNode) {
    String id = '${defNode.id}';
    if (!_suspendedDefs.containsKey(id)) {
      svg.SvgElement defImplEl = _element.querySelector('#$id');
      if (defImplEl != null) {
        svg.SvgElement dummy = defImplEl.clone(true);
        dummy.classes.add("dummy");
        _suspendedDefs[id] = defImplEl;
        defImplEl.replaceWith(dummy);
      }
    }
  }

  void resumeDef(Node defNode) {
    String id = '${defNode.id}';
    if (_suspendedDefs.containsKey(id)) {
      svg.SvgElement dummy = _element.querySelector('#$id');
      if (dummy != null) {
        dummy.replaceWith(_suspendedDefs[id]);
        _suspendedDefs.remove(id);
      }
    }
  }
}

class DefLayer {
  static final Map<Canvas, DefLayerImpl> _impls = {};

  static DefLayerImpl impl(Canvas canvas) {
    var impl = _impls[canvas];
    if (impl == null) {
      impl = _impls[canvas] = new DefLayerImpl();
      canvas.insertChild(0, impl._layer);
    }
    return impl;
  }
}
