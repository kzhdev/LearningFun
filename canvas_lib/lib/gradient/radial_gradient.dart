part of canvas;

class RadialGradient extends Gradient {
  RadialGradient([Map<String, dynamic> config = const {}]) : super(config);

  @override
  Node _clone(Map<String, dynamic> config) => new RadialGradient(config);

  @override
  NodeImpl createImpl([bool isReflection = false]) =>
      new RadialGradientImpl(this);
}
