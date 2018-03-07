part of canvas;

enum ControlType {
  e, w, n, s, ne, nw, se, sw, r
}

abstract class ControlPoint extends Object with DraggableNodeImpl {
  final svg.GElement _controlGroup;

  static const size = 8;
  static const csClassName = '__control_point';

  StreamSubscription _mouseOverStream;
  StreamSubscription _mouseOutStream;

  static ControlPoint factory(svg.GElement controlGroup, Node node, ControlType type, NodeImpl reflection) {
    switch (type) {
      case ControlType.n:
        return new NControlPoint(controlGroup, node, reflection);
      case ControlType.s:
        return new SControlPoint(controlGroup, node, reflection);
      case ControlType.w:
        return new WControlPoint(controlGroup, node, reflection);
      case ControlType.e:
        return new EControlPoint(controlGroup, node, reflection);
      case ControlType.nw:
        return new NWControlPoint(controlGroup, node, reflection);
      case ControlType.ne:
        return new NEControlPoint(controlGroup, node, reflection);
      case ControlType.sw:
        return new SWControlPoint(controlGroup, node, reflection);
      case ControlType.se:
        return new SEControlPoint(controlGroup, node, reflection);
      case ControlType.r:
        throw new Exception('not implemented');
    }
    throw new Exception('Invalid ControlType');
  }

  ControlPoint(this._controlGroup, Node node, NodeImpl reflection) {

    initDraggable(node, new svg.RectElement());

    _element.attributes.addAll({
      WIDTH: '$size',
      HEIGHT: '$size',
    });

    _element.style.setProperty('fill', 'black');
    _element.classes.add(csClassName);

    reflection._controlPoints.add(this);
    _controlGroup.append(_element);

    _mouseOverStream = _element.onMouseOver.listen(_onMouseOver);
    _mouseOutStream = _element.onMouseOut.listen(_onMouseOut);

    enableDragging();

    _node.on([scaleXChanged, scaleYChanged, scaleChanged, resize],
        updatePosition, runtimeType.toString());

    updatePosition();
  }

  void remove() {
    var suid = runtimeType.toString();
    _node
      ..off(scaleXChanged, suid)
      ..off(scaleYChanged, suid)
      ..off(scaleChanged, suid)
      ..off(resize, suid)
    ;

    disableDragging();

    _mouseOverStream.cancel();
    _mouseOutStream.cancel();

    _element.remove();
    _element = null;

    _node = null;
  }

  void  updatePosition() {
    var bbx = nodeBBox;
    var pos = getPosition(bbx);

    var matrix = new svg.SvgSvgElement().createSvgMatrix();
    matrix = matrix.translate(
      pos.x + bbx.x * resizeScaleX,
      pos.y + bbx.y * resizeScaleY
    );

    var graphEl = (_element as svg.GraphicsElement);
    var tr = graphEl.transform.baseVal.createSvgTransformFromMatrix(matrix);
    if (graphEl.transform.baseVal.numberOfItems == 0) {
      graphEl.transform.baseVal.appendItem(tr);
    } else {
      graphEl.transform.baseVal.replaceItem(tr, 0);
    }
  }

  void _onMouseOver(dom.MouseEvent e) {
    dom.document.body.style.cursor = cursor;
    e.stopPropagation();
  }

  void _onMouseOut(dom.MouseEvent e) {
    dom.document.body.style.cursor = 'default';
    e.stopPropagation();
  }

  @override
  bool handleDragMove(dom.MouseEvent e, num diffX, num diffY) {
    _calculateDragOffset();
    e.preventDefault();
    e.stopImmediatePropagation();
    e.stopPropagation();
    return false;
  }

  num _getNewWidth(num w, num diffX, int factor) {
    var w1 = w + factor * diffX;

    var minW = _node.getAttribute(MIN_WIDTH);
    if (minW != null) {
      w1 = max(minW, w1);
    }

    var maxW  = _node.getAttribute(MAX_WIDTH);
    if (maxW != null) {
      w1 = min(maxW, w1);
    }

    return w1;
  }

  num _getNewHeight(num h, num diffY, int factor) {
    var h1 = h + factor * diffY;

    var minH = _node.getAttribute(MIN_HEIGHT);
    if (minH != null) {
      h1 = max(minH, h1);
    }

    var maxH = _node.getAttribute(MAX_HEIGHT);
    if (maxH != null) {
      h1 = min(maxH, h1);
    }
    return h1;
  }

  num get resizeScaleX => _node.getAttribute(RESIZE_SCALE_X, 1);
  num get resizeScaleY => _node.getAttribute(RESIZE_SCALE_Y, 1);
  int get negativeScaleXAdjustment => resizeScaleX > 0 ? 0 : -size;
  int get negativeScaleYAdjustment => resizeScaleY > 0 ? 0 : -size;

  BBox get nodeBBox {
    var bbox = (_controlGroup.children[0] as svg.GraphicsElement).getBBox();
    return new BBox(
      x: bbox.x,
      y: bbox.y,
      width: bbox.width * _node.scaleX * _node.getAttribute(RESIZE_SCALE_X, 1),
      height: bbox.height * _node.scaleY * _node.getAttribute(RESIZE_SCALE_Y, 1)
    );
  }

  Position getPosition(BBox bbox);

  String get cursor;

}
