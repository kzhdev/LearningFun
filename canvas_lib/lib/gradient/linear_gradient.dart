part of canvas;

class LinearGradient extends Gradient {
  LinearGradient([Map<String, dynamic> config = const {}]) : super(config);

  @override
  Node _clone(Map<String, dynamic> config) => new LinearGradient(config);

  @override
  NodeImpl createImpl([bool isReflection = false]) =>
      new LinearGradientImpl(this);
}
