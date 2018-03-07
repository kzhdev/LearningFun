part of canvas;

class FilterImpl extends NodeImpl {

  FilterImpl(Filter shell) : super(shell, false);

  @override
  svg.SvgElement _createElement() {
    var el = new svg.FilterElement();
    _createFilters(el);
    return el;
  }

  @override
  dynamic getAttribute(String attr, [dynamic defaultValue = null]) {
    if (attr == ID) {
      return super.getAttribute(attr, defaultValue != null ? defaultValue : shell.id);
    } else {
      return super.getAttribute(attr, defaultValue);
    }
  }

  @override
  Set<String> _getElementAttributeNames() {
    var rt = super._getElementAttributeNames();
    rt.addAll(['filterUnits', 'primitiveUnits', X, Y, WIDTH, HEIGHT, 'filerRes']);
    return rt;
  }

  void _createFilters(svg.FilterElement el) {
    shell.attrs.forEach((String filterName, config) {
      switch(filterName) {
        case 'GaussianBlur':
          var feGaussianBlur = new svg.FEGaussianBlurElement();
          feGaussianBlur.attributes.addAll(config);
          el.append(feGaussianBlur);
          break;

        case 'Offset':
          var feOffset = new svg.FEOffsetElement();
          feOffset.attributes.addAll(config);
          el.append(feOffset);
          break;

        case 'Merge':
          if (config is List<Map<String, dynamic>>) {
            var feMerge = new svg.FEMergeElement();
            for (var mergeNode in config) {
              var feMergeNode = new svg.FEMergeNodeElement();
              feMergeNode.attributes.addAll(mergeNode);
              feMerge.nodes.add(feMergeNode);
            }
            el.append(feMerge);
          }
          break;

        case 'SpecularLighting':
          var fsSpecularLighting = new svg.FESpecularLightingElement();
          for (var key in config.keys) {
            if (key == 'PointLight') {
              var pointLight = new svg.FEPointLightElement();
              pointLight.attributes.addAll(config[key]);
              fsSpecularLighting.append(pointLight);
            } else {
              fsSpecularLighting.setAttribute(key, config[key]);
            }
          }
          el.append(fsSpecularLighting);
          break;

        case 'Composite':
//          var fsComposite = new svg.FECompositeElement.internal_();
          var fsComposite = new svg.SvgElement.tag('fsComposite');
          fsComposite.attributes.addAll(config);
          el.append(fsComposite);
      }
    });
  }
}
