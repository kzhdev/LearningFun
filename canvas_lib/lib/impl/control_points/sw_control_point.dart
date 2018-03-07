part of canvas;

class SWControlPoint extends ControlPoint {

  SWControlPoint(svg.GElement controlGroup, Node node, NodeImpl reflection)
    :super(controlGroup, node, reflection);

  @override
  Position getPosition(BBox bbox) {
    return new Position(
      x: -ControlPoint.size - negativeScaleXAdjustment,
      y: bbox.height + negativeScaleYAdjustment
    );
  }

  @override
  String get cursor => 'nesw-resize';

  @override
  bool handleDragMove(dom.MouseEvent e, num diffX, num diffY) {

    var bbox = nodeBBox;
    var w = bbox.width;
    var w1 = _getNewWidth(w, diffX, -1);
    if (w != w1) {
      _node.x += diffX;
    }

    var h = bbox.height;
    var h1 = _getNewHeight(h, diffY, 1);
    _node.setAttribute(RESIZE_SCALE_X, resizeScaleX * w1 / w);
    _node.setAttribute(RESIZE_SCALE_Y, resizeScaleY * h1 / h);
    _node.fire(resize);
    return super.handleDragMove(e, diffX, diffY);
  }
}
