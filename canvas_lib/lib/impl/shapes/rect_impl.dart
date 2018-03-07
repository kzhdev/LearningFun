part of canvas;

class RectImpl extends NodeImpl {
  RectImpl(Rect shell, bool isReflection): super(shell, isReflection);

  @override
  svg.SvgElement _createElement() => new svg.RectElement();

  @override
  Set<String> _getElementAttributeNames() {
    var attrs = super._getElementAttributeNames();
    attrs.addAll([X, Y, RX, RY, WIDTH, HEIGHT]);
    return attrs;
  }
}
