part of canvas;

class LinearGradientImpl extends GradientImpl {

  LinearGradientImpl(LinearGradient shell) : super(shell);

//  @override
//  svg.SvgElement _createElement() {
//    var el = new svg.LinearGradientElement();
//    el.nodes.addAll(_getStopElements());
//    return el;
//  }

  @override
  svg.SvgElement __createElement() => new svg.LinearGradientElement();

//  @override
//  dynamic getAttribute(String attr, [dynamic defaultValue = null]) {
//    if (attr == ID) {
//      return super.getAttribute(attr, defaultValue != null ? defaultValue : shell.id);
//    } else {
//      return super.getAttribute(attr, defaultValue);
//    }
//  }
//
//  List<svg.StopElement> _getStopElements() {
//    List<svg.StopElement> stopElements = [];
//    stops.forEach((stop) {
//      var stopEl = new svg.StopElement();
//      stopEl.setAttribute(OFFSET, getValue(stop, OFFSET, '0%'));
//      var color = stop[COLOR];
//      if (color != null) {
//        stopEl.style.setProperty('stop-color', '$color');
//      }
//      var opacity = stop[OPACITY];
//      if (opacity != null) {
//        stopEl.style.setProperty('stop-opacity', '$opacity');
//      }
//      stopElements.add(stopEl);
//    });
//    return stopElements;
//  }

  @override
  Set<String> _getElementAttributeNames() {
    var rt = super._getElementAttributeNames();
    rt.addAll([X1, Y1, X2, Y2, SPREAD_METHOD]);
    return rt;
  }
//
//  void set stops(List<Map<String, dynamic>> value) => setAttribute(STOPS, value);
//  List<Map<String, dynamic>> get stops => getAttribute(STOPS, []) as List<Map<String, dynamic>>;
}
