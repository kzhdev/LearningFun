part of canvas;

class PolygonImpl extends PolyShapeImpl {

  PolygonImpl(Polygon shell, bool isReflection): super(shell, isReflection);

  @override
  svg.SvgElement _createElement() => new svg.PolygonElement();
}
