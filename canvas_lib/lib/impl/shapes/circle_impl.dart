part of canvas;

class CircleImpl extends NodeImpl {

  CircleImpl(Circle shell, bool isReflection): super(shell, isReflection);

  @override
  svg.SvgElement _createElement() => new svg.CircleElement();

  @override
  Set<String> _getElementAttributeNames() {
    var attrs = super._getElementAttributeNames();
    attrs.addAll([CX, CY, R]);
    return attrs;
  }

  @override
  dynamic getAttribute(String attr, [dynamic defaultValue = null]) {
    switch (attr) {
      case CX:
        return super.getAttribute(X, defaultValue);
      case CY:
        return super.getAttribute(Y, defaultValue);
      default:
        return super.getAttribute(attr, defaultValue);
    }
  }

  @override
  String _mapToElementAttr(String attr) {
    switch (attr) {
      case X:
        return CX;
      case Y:
        return CY;
      default:
        return super._mapToElementAttr(attr);
    }
  }
}
