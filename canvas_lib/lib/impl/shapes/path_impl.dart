part of canvas;

class PathImpl extends NodeImpl {
  PathImpl(Path shell, bool isReflection) : super(shell, isReflection) {
    this.shell.on('dChanged', () => _setElementAttribute(D));
  }

  @override
  svg.SvgElement _createElement() => new svg.PathElement();

  @override
  Set<String> _getElementAttributeNames() {
    var attrs = super._getElementAttributeNames();
    attrs.addAll([D]);
    return attrs;
  }

}
