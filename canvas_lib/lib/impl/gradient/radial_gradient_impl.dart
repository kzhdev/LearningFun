part of canvas;

class RadialGradientImpl extends GradientImpl {
  RadialGradientImpl(RadialGradient shell) : super(shell);

  @override
  svg.SvgElement __createElement() => new svg.RadialGradientElement();

  @override
  Set<String> _getElementAttributeNames() {
    var rt = super._getElementAttributeNames();
    rt.addAll([CX, CY, R, FX, FY, SPREAD_METHOD]);
    return rt;
  }
}
