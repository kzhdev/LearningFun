part of canvas;

abstract class NodeImpl extends Object with DraggableNodeImpl {
  var parent;
  final Node shell;

  svg.GElement _controlGroup;
  svg.SvgElement _implElement;

  final Set<String> _registeredDOMEvents = new Set<String>();
  final List<ControlPoint> _controlPoints = [];

  StreamSubscription<String> _onLocationChanged;

  bool _isReflection;
  num _controlGroupX0 = 0;
  num _controlGroupY0 = 0;

  NodeImpl(Node this.shell, this._isReflection) {
    _implElement = _createElement();

    if (shell.resizable) {
      _createControlGroup();
    }

    _setElementAttributes();
    _setElementStyles();

    transform();

    if (shell.isListening) {
      shell.eventListeners.forEach((k, v) {
        _registerEvent(k, v);
      });
    }

    // only handle dragging on a reflection node
    if (_isReflection) {
      if (this is! ContainerNodeImpl) {
        _implElement.style.setProperty(OPACITY, '0');
      }

      initDraggable(shell, element);

      if (getAttribute(DRAGGABLE) == true) {
        enableDragging();
      }

      shell
        ..on('reflection_complete', _onReflectionComplete)
        ..on('draggableChanged', (newValue) {
          if (newValue) {
            enableDragging();
          } else {
            disableDragging();
          }
        });
    }

    shell
      ..on([
        translateXChanged,
        translateYChanged,
        translateChanged,
        'offsetXChanged',
        'offsetYChanged',
        'rotationChanged'
      ], transform)
      ..on([
        scaleXChanged,
        scaleYChanged,
        scaleChanged,
        resize,
      ], _handleScaleChange)
      ..on(attrChanged, _handleAttrChange);
  }

  void _createControlGroup() {
    _controlGroup = new svg.GElement();

    _controlGroup.append(_implElement);
  }

  void _createControlPoints() {
    if (_isReflection) {
      var types = getAttribute(CONTROLS);
      if (types != null && types is List<String>) {
        for (String type in types) {
          switch (type) {
            case 'n':
              ControlPoint.factory(_controlGroup, shell, ControlType.n, this);
              break;
            case 's':
              ControlPoint.factory(_controlGroup, shell, ControlType.s, this);
              break;
            case 'w':
              ControlPoint.factory(_controlGroup, shell, ControlType.w, this);
              break;
            case 'e':
              ControlPoint.factory(_controlGroup, shell, ControlType.e, this);
              break;
            case 'nw':
              ControlPoint.factory(_controlGroup, shell, ControlType.nw, this);
              break;
            case 'ne':
              ControlPoint.factory(_controlGroup, shell, ControlType.ne, this);
              break;
            case 'sw':
              ControlPoint.factory(_controlGroup, shell, ControlType.sw, this);
              break;
            case 'se':
              ControlPoint.factory(_controlGroup, shell, ControlType.se, this);
              break;
          }
        }
      } else {
        for (var type in [
          ControlType.e,
          ControlType.w,
          ControlType.n,
          ControlType.s,
          ControlType.ne,
          ControlType.nw,
          ControlType.se,
          ControlType.sw
        ]) {
          ControlPoint.factory(_controlGroup, shell, type, this);
        }
      }
    }
  }

  void _onReflectionComplete() {
    if (this is GroupImpl) {
      for (var child in (this as GroupImpl).children) {
        child._onReflectionComplete();
      }
    }
  }

  svg.SvgElement get element => _controlGroup ?? _implElement;

  svg.SvgElement _createElement();

  Set<String> _getElementAttributeNames() => new Set<String>.from([ID, CLASS]);

  List<String> _getStyleNames() => [
        STROKE,
        STROKE_WIDTH,
        STROKE_DASHARRAY,
        FILL,
        OPACITY,
        DISPLAY,
        CURSOR,
        FILTER
      ];

  void _setElementAttributes() {
    var attrs = _getElementAttributeNames();
    var needToTransform = false;

    for (var attr in attrs) {
      var b = _setElementAttribute(attr);
      if (needToTransform == false && b) {
        needToTransform = true;
      }
    }

    if (needToTransform) {
      transform();
    }
  }

  bool _setElementAttribute(String attr) {
    var value = getAttribute(attr);
    var needToTransform = false;
    if (value != null) {
      if (!(value is String) || !value.isEmpty) {
        if (_controlGroup != null) {
          if (_isPositionAttr(attr)) {
            if (value != null) {
              if (attr == X) {
                _controlGroupX0 = value;
                needToTransform = true;
              } else if (attr == Y) {
                _controlGroupY0 = value;
                needToTransform = true;
              }
            }
          } else if (_isSizeAttr(attr)) {
            _controlGroup.attributes[attr] = '$value';
            _implElement.attributes[attr] = '$value';
          } else {
            _implElement.attributes[attr] = '$value';
          }
        } else {
          _implElement.attributes[attr] = '$value';
        }
      }
    }
    return needToTransform;
  }

  bool _isPositionAttr(String attr) => attr == X || attr == Y;
  bool _isSizeAttr(String attr) => attr == WIDTH || attr == HEIGHT;

  void _setElementStyles() {
    _getStyleNames().forEach((name) {
      _setElementStyle(name);
    });
  }

  void _setPropertyUrl(String propName, [dynamic value = null]) {
    var val = value ?? getAttribute(propName);

    _implElement.style
        .setProperty(propName, 'url(${Canvas.location}#${val.id})');

    // On FireFox there is some strageness, the fill pattern or gradient
    // is not always take effect. This is a hack to force FireFox repaint the
    // the block so that pattern and gradient can show up.
    if (dom.window.navigator.userAgent.toLowerCase().contains('firefox')) {
      val.on(defAdded, () {
        _implElement.style.setProperty(propName, 'transparent');
        new Future.delayed(new Duration(seconds: 0), () {
          _implElement.style
              .setProperty(propName, 'url(${Canvas.location}#${val.id})');
        });
      });
    }
  }

  void _setElementStyle(String name) {
    var value = getAttribute(name);
    if (value != null) {
      if (value is CanvasPattern || value is Gradient || value is Filter) {
        if (_isReflection) {
          _implElement.style.setProperty(name, 'trasparent');
        } else {
          var baseTag = dom.document.querySelector('base');
          if (baseTag == null) {
            _setPropertyUrl(name, value);

            if (_onLocationChanged != null) {
              _onLocationChanged.cancel();
              _onLocationChanged = null;
            }
          } else {
            _setPropertyUrl(name, value);

            _onLocationChanged = Canvas.onLocationChange.listen((_) {
              _setPropertyUrl(name);
            });
          }
        }
        return;
      }

      if (name == STROKE_WIDTH) {
        value /= max(shell.actualScaleX, shell.actualScaleY);
      }
      if (!_isReflection || name != 'opacity') {
        _implElement.style.setProperty(name, '${value}');
      }
    } else {
      _implElement.style.removeProperty(name);
    }

    if (name == FILL && _onLocationChanged != null) {
      // Fill no longer a pattern or gradient, stop location check timer
      _onLocationChanged.cancel();
      _onLocationChanged = null;
    }
  }

  void remove() {
    if (_onLocationChanged != null) {
      _onLocationChanged.cancel();
      _onLocationChanged = null;
    }

    element.remove();

    if (canvas != null && !_isReflection) {
      for (var def in _defs) {
        DefLayer.impl(canvas).removeDef(def);
      }
    }

    if (parent != null) {
      (parent as Container).children.remove(this);
    }
    parent = null;
  }

  void _registerEvent(String event, EventHandlers handlers) {
    if (isDomEvent(event)) {
      if (_isReflection && !_registeredDOMEvents.contains(event)) {
        _registeredDOMEvents.add(event);
        switch (event) {
          case mouseDown:
            element.onMouseDown.listen((e) => handlers(e));
            break;
          case mouseUp:
            element.onMouseUp.listen((e) => handlers(e));
            break;
          case mouseEnter:
            element.onMouseEnter.listen((e) => handlers(e));
            break;
          case mouseLeave:
            element.onMouseLeave.listen((e) => handlers(e));
            break;
          case mouseOver:
            element.onMouseOver.listen((e) => handlers(e));
            break;
          case mouseOut:
            element.onMouseOut.listen((e) => handlers(e));
            break;
          case mouseMove:
            element.onMouseMove.listen(_onMouseMove);
            break;
          case click:
            element.onClick.listen((e) => handlers(e));
            break;
          case dblClick:
            element.onDoubleClick.listen((e) => handlers(e));
            break;
        }
      }
    } else {
      element.on[event].listen((e) => handlers(e));
    }
  }

  void _onMouseMove(dom.MouseEvent e) {
    if (!_dragging) {
      shell.fire(mouseMove, e);
    }
  }

  void on(String event, Function handler, [String id]) {
    if (!_registeredDOMEvents.contains(event)) {
      _registerEvent(event, shell.eventListeners[event]);
    }
  }

  void _handleAttrChange(String attr, newValue, oldValue) {
    if (_isStyle(attr)) {
      // only handle def changes on non-reflection node
      if (canvas != null && !_isReflection) {
        _updateDef(attr, oldValue, remove: true);
        _updateDef(attr, newValue);
      }
      _setElementStyle(attr);
    } else {
      // apply attribute change to svg element
      var elementAttr = _mapToElementAttr(attr);
      if (elementAttr != null) {
        if (_setElementAttribute(elementAttr)) {
          transform();
        }
      }
    }
  }

  void _updateDef(String attr, value, {bool remove: false}) {
    if (value is CanvasPattern || value is LinearGradient || value is Filter) {
      if (remove) {
        DefLayer.impl(canvas).removeDef(value);
        _implElement.style.removeProperty(attr);
      } else if (layer != null) {
        DefLayer.impl(canvas).addDef(value);
      }
    }
  }

  bool _isStyle(String attr) => _getStyleNames().contains(attr);

  String _mapToElementAttr(String attr) {
    if (_getElementAttributeNames().contains(attr)) {
      return attr;
    }
    return null;
  }

  void _handleScaleChange() {
    // do not scale strokeWidth
    var strokeWidth =
        shell.strokeWidth / max(shell.actualScaleX, shell.actualScaleY);
    _implElement.style.setProperty(STROKE_WIDTH, strokeWidth.toString());
    transform();
  }

  void transform() {
    var r = shell.rotate;

    var trans = ""; // transform
    var tx = 0, ty = 0; // translateX, translateY

    if (r != null) {
      var rx = shell.x + shell.getAttribute(ROTATE_X, 0);
      var ry = shell.y + shell.getAttribute(ROTATE_Y, 0);
      if (rx != 0 || ry != 0) {
        trans = "translate($rx, $ry) rotate(${r}deg) ";
        tx = -rx;
        ty = -ry;
      } else {
        trans = "rotate(${r}deg) ";
      }
    }

    tx += _controlGroupX0 + shell.translateX;
    ty += _controlGroupY0 + shell.translateY;

    trans = _scale(trans, tx, ty);

    if (element is svg.GraphicsElement) {
      _setTransform(element, trans);
    }
  }

  void _setTransform(svg.GraphicsElement el, String trans) {
    el.setAttribute("transform", trans);
  }

  String _scale(String trans, num tx, num ty) {
    var sx = shell.scaleX * shell.getAttribute(RESIZE_SCALE_X, 1);
    var sy = shell.scaleY * shell.getAttribute(RESIZE_SCALE_Y, 1);

    if (sx == 1 && sy == 1) {
      trans += "translate(${tx.toInt()}, ${ty.toInt()})";
      return trans;
    }

    // only scale node, not the control group
    if (_controlGroup != null) {
      trans += "translate(${tx.toInt()}, ${ty.toInt()})";
      _setTransform(_implElement, "scale($sx, $sy)");
    } else {
      // scale at note origin
      tx += (translateX - shell.x) * (sx - 1);
      ty += (translateY - shell.y) * (sy - 1);

      trans += "translate(${tx.toInt()}, ${ty.toInt()}) scale($sx, $sy)";
    }
    return trans;
  }

  void showControlPoints([dom.MouseEvent e]) {
    if (_controlGroup != null) {
      _createControlPoints();
    }
  }

  void hideControlPoints([dom.MouseEvent e]) {
    if (_controlGroup == null || e != null && e.path.contains(_controlGroup)) {
      return;
    }

    for (var cp in _controlPoints) {
      cp.remove();
    }
    _controlPoints.clear();
  }

  bool get isDragging => _dragging;

  List get _defs {
    var defs = [];

    // don't add defs on reflection layer
    if (_isReflection) {
      return defs;
    }

    if (fill is CanvasPattern || fill is Gradient) {
      defs.add(fill);
    }

    if (filter != null) {
      defs.add(filter);
    }

    if (stroke is CanvasPattern) {
      defs.add(stroke);
    }
    return defs;
  }

  bool get hasControls => _controlGroup != null && _controlPoints.isNotEmpty;

  BBox getBBox(bool isAbsolute) {
    svg.GraphicsElement graphEl = element;
    var bbx = graphEl.getBBox();

    if (isAbsolute) {
      var absPos = shell.absolutePosition;
      return new BBox(
          x: absPos.x, y: absPos.y, width: bbx.width, height: bbx.height);
    } else {
      return _controlGroup != null
          ? new BBox(
              x: shell.x, y: shell.y, width: bbx.width, height: bbx.height)
          : new BBox(x: bbx.x, y: bbx.y, width: bbx.width, height: bbx.height);
    }
  }

  LayerImpl get layer =>
      _isReflection ? canvas._reflectionLayer.impl : shell.layer?.impl;

  Canvas get canvas => shell.canvas;

  void setAttribute(String attr, value, [bool removeIfNull = false]) =>
      shell.setAttribute(attr, value, removeIfNull);

  getAttribute(String attr, [defaultValue = null]) =>
      shell.getAttribute(attr, defaultValue);

  String get id => shell.id;

  num get width => shell.width;
  num get height => shell.height;

  void set fill(value) {
    shell.fill = value;
  }

  get fill => shell.fill;

  void set stroke(value) {
    shell.stroke = value;
  }

  get stroke => shell.stroke;

  void set strokeWidth(num value) {
    shell.strokeWidth = value;
  }

  num get strokeWidth => shell.strokeWidth;

  void set translateX(num value) {
    shell.translateX = value;
  }

  num get translateX => shell.translateX;

  void set translateY(num value) {
    shell.translateY = value;
  }

  num get translateY => shell.translateY;

  Filter get filter => shell.filter;
}
