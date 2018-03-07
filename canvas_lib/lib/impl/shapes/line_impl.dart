part of canvas;

class LineImpl extends NodeImpl {
  LineImpl(Line shell, bool isReflection): super(shell, isReflection);

  @override
  svg.SvgElement _createElement() => new svg.LineElement();

  @override
  Set<String> _getElementAttributeNames() {
    var attrs = super._getElementAttributeNames();
    attrs.addAll([X1, Y1, X2, Y2]);
    return attrs;
  }
}
