part of canvas;

class NControlPoint extends ControlPoint {

  NControlPoint(svg.GElement controlGroup, Node node, NodeImpl reflection)
    :super(controlGroup, node, reflection);

  @override
  Position getPosition(BBox bbox) {
    var middleX = (bbox.width - ControlPoint.size) / 2;
    return new Position(
      x: middleX,
      y: (-ControlPoint.size - negativeScaleYAdjustment - _node.strokeWidth / 2).floor()
    );
  }

  @override
  String get cursor => 'ns-resize';

  @override
  bool handleDragMove(dom.MouseEvent e, num diffX, num diffY) {

    var h = nodeBBox.height;
    var h1 = _getNewHeight(h, diffY, -1);

    if (h != h1) {
      _node.y += diffY;
    }
    _node.setAttribute(RESIZE_SCALE_Y, resizeScaleY * h1 / h);
    _node.fire(resize);

    return super.handleDragMove(e, diffX, diffY);
  }
}
