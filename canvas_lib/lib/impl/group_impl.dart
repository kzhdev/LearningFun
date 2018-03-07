part of canvas;

class GroupImpl extends ContainerNodeImpl {

  GroupImpl(Group shell, bool isReflection) : super(shell, isReflection);

  @override
  svg.SvgElement _createElement() => new svg.GElement();

  @override
  Set<String> _getElementAttributeNames() {
    var attrs = super._getElementAttributeNames();
    attrs.addAll([X, Y, WIDTH, HEIGHT]);
    return attrs;
  }

  @override
  bool _setElementAttribute(String attr) {
    var rt = super._setElementAttribute(attr);
    var value = shell.attrs[attr];

    if (attr == X) {
      _implElement.attributes.remove(X);
      if (value != null) {
        shell.translateX = value;
        rt = true;
      }
    } else if (attr == Y) {
      _implElement.attributes.remove(Y);
      if (value != null) {
        shell.translateY = value;
        rt= true;
      }
    }
    return rt;
  }
}
