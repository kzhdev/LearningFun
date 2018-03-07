part of canvas;

class Canvas extends NodeBase with Container<Node> {
  dom.Element _container;
  dom.Element _element;
  Layer _defaultLayer;

  _ReflectionLayer _reflectionLayer;

  Position _pointerPosition;
  Position _pointerScreenPosition;
  bool _dragStarting = false;
  bool _dragging = false;
  bool _dragStarted = false;
  bool _dragCanceled = false;
  Position _preDragPointerPosition;
  AnimationLoop _animLoop = new AnimationLoop();

  static String _preLocation = location;
  static final _locationChangedStreamController =
      new StreamController<String>.broadcast();

  final TransformMatrix _transformMatrix = new TransformMatrix();

  Canvas(this._container, {Map<String, dynamic> config: const {}})
      : super(config) {
    _populateConfig(config);
    _createElement();

    if (_container == null) {
      throw "container doesn't exit";
    }

    if (getValue(config, CREATE_SHADOW_ROOT, false)) {
      _container.createShadowRoot().append(this._element);
    } else {
      _container.nodes.add(this._element);
    }

    _reflectionLayer =
        new _ReflectionLayer({WIDTH: this.width, HEIGHT: this.height});
    _reflectionLayer.canvas = this;
    children.add(_reflectionLayer);
    _element.nodes.add(_reflectionLayer.impl.element);

    _element.onMouseDown.listen(_onMouseDown);
    _element.onMouseMove.listen(_onMouseMove);
    _element.onMouseUp.listen(_onMouseUp);
    _element.onMouseEnter.listen(_setPointerPosition);
    _element.onMouseLeave.listen(_setPointerPosition);
    _element.onMouseOver.listen((e) {
      _setPointerPosition(e);
      fire(canvasMouseOver);
    });
    _element.onMouseOut.listen(_setPointerPosition);
    _element.onMouseWheel.listen(_setPointerPosition);

    this.on('draggableChanged', (newValue) {
      if (!newValue) {
        _dragEnd();
      }
    });
  }

  void remove() {
    this._element.remove();
  }

  void _createElement() {
    String c = getAttribute(CLASS);
    _element = new dom.DivElement();
    if (id != null && !id.isEmpty) {
      _element.id = id;
    }
    _element.classes.add('canvas');
    if (c != null) {
      _element.classes.addAll(c.split(space));
    }
    _element.setAttribute('role', 'presentation');
    _element.style
      ..display = 'inline-block'
      ..position = 'relative'
      ..width = '${getAttribute(WIDTH)}px'
      ..height = '${getAttribute(HEIGHT)}px'
      ..margin = '0'
      ..padding = '0';
  }

  void _populateConfig(Map<String, dynamic> config) {
    if (getAttribute(WIDTH) == null) {
      setAttribute(WIDTH, _container.clientWidth);
    }

    if (getAttribute(HEIGHT) == null) {
      setAttribute(HEIGHT, _container.clientHeight);
    }

    var s = getAttribute(SCALE);
    if (s != null) {
      scale(s, s);
    } else {
      s = getAttribute(SCALE_X);
      if (s != null) {
        scaleX = s;
      }

      s = getAttribute(SCALE_Y);
      if (s != null) {
        scaleY = s;
      }
    }
  }

  void _onMouseDown(e) {
    _setPointerPosition(e);
    fire(canvasMouseDown, e);
    if (isDraggable) {
      _dragStart(e);
    }
  }

  void _onMouseMove(e) {
    _setPointerPosition(e);
    fire(canvasMouseMove, e);
    if (_dragStarting || _dragging) {
      _dragMove(e);
    }
  }

  void _onMouseUp(e) {
    _setPointerPosition(e);
    fire(canvasMouseUp, e);
    _dragEnd(e);
  }

  void _setPointerPosition(e) {
    var elementClientRect = _element.getBoundingClientRect();
    var x = (e.client.x - elementClientRect.left) / _transformMatrix.scaleX -
        _transformMatrix.translateX;
    var y = (e.client.y - elementClientRect.top) / _transformMatrix.scaleY -
        _transformMatrix.translateY;
    _pointerPosition = new Position(x: x, y: y);
    _pointerScreenPosition = new Position(x: e.client.x, y: e.client.y);
  }

  void _updatePointerPositionXFromScaleXChange(num newScaleX, num oldScaleX) {
    if (_pointerPosition != null) {
      var factor = oldScaleX / newScaleX;
      _pointerPosition.x = _pointerPosition.x * factor +
          _transformMatrix.translateX * (factor - 1);
    }
  }

  void _updatePointerPositionYFromScaleYChange(num newScaleY, num oldScaleY) {
    if (_pointerPosition != null) {
      var factor = oldScaleY / newScaleY;
      _pointerPosition.y = _pointerPosition.y * factor +
          _transformMatrix.translateY * (factor - 1);
    }
  }

  void _updatePointerPositionXFromTranslateXChange(
      num newTransX, num oldTransX) {
    if (_pointerPosition != null) {
      _pointerPosition.x += oldTransX - newTransX;
    }
  }

  void _updatePointerPositionYFromTranslateYChange(
      num newTransY, num oldTransY) {
    if (_pointerPosition != null) {
      _pointerPosition.y += oldTransY - newTransY;
    }
  }

  Position get pointerPosition => _pointerPosition;
  Position get pointerScreenPosition => _pointerScreenPosition;

  @override
  void addChild(Node node) {
    if (node is Layer) {
      node.canvas = this;
      node._reflection = _reflectionLayer.impl;

      if (node.width == null) {
        node.width = this.width;
        node.height = this.height;
      }

      if (_reflectionLayer != null) {
        int index = _element.nodes.indexOf(_reflectionLayer.impl.element);
        _element.nodes.insert(index, node.impl.element);
        children.insert(index, node);

        node.children.forEach((child) {
          _reflectionLayer.reflectNode(child);
        });
      } else {
        _element.nodes.add(node.impl.element);
        children.add(node);
      }
    } else {
      if (_defaultLayer == null) {
        _defaultLayer =
            new Layer({ID: '__default_layer', WIDTH: width, HEIGHT: height});
        addChild(_defaultLayer);
      }
      _defaultLayer.addChild(node);
    }
  }

  @override
  void removeChild(Node node) {
    if (node is Layer) {
      children.remove(node);
      node._canvas = null;
      node._reflection = null;
    } else {
      _defaultLayer.removeChild(node);
    }
  }

  @override
  void clearChildren() {
    for (var i = 0; i < children.length;) {
      var child = children[i];
      if (child != _reflectionLayer) {
        removeChild(child);
      } else {
        ++i;
      }
    }
  }

  @override
  void insertChild(int index, Node node) {
    if (node is Layer) {
      node.canvas = this;

      children.insert(index, node);
      if (node.width == null) {
        node.width = this.width;
        node.height = this.height;
      }
      _element.nodes.insert(index, node.impl.element);

      if (_reflectionLayer != null) {
        node._reflection = _reflectionLayer.impl;
        node.children.forEach((child) {
          _reflectionLayer.reflectNode(child);
        });
      }
    } else {
      _defaultLayer.insertChild(index, node);
    }
  }

  void _dragStart(dom.MouseEvent e) {
    if (_dragStarting || _dragging) {
      return;
    }

    e.preventDefault();
    e.stopPropagation();

    _dragStarting = true;

    _preDragPointerPosition = _pointerPosition;
  }

  void _dragMove(dom.MouseEvent e) {
    e.preventDefault();
    e.stopPropagation();

    if (!_dragStarted && !_dragCanceled) {
      var event = {'nativeEvent': e, 'canceled': false};

      fire(dragStart, event);
      if (event['canceled']) {
        _dragCanceled = true;
        _dragStarting = false;
        return;
      }

      _dragStarting = false;
      _dragging = true;
      _dragStarted = true;

      _animLoop.subscribe(this.uid.toString(), (_) {
        translate(
            (translateX + _pointerPosition.x - _preDragPointerPosition.x)
                .floor(),
            (translateY + _pointerPosition.y - _preDragPointerPosition.y)
                .floor());

        _preDragPointerPosition = _pointerPosition;
        fire(dragMove, e);
      });
    }
  }

  void _dragEnd([dom.MouseEvent e]) {
    if (e != null) {
      e.preventDefault();
      e.stopPropagation();
    }
    _dragStarting = false;
    _dragging = false;

    if (_dragStarted) {
      translate(
          (translateX + _pointerPosition.x - _preDragPointerPosition.x).floor(),
          (translateY + _pointerPosition.y - _preDragPointerPosition.y)
              .floor());
      _animLoop.unsubscribe(this.uid.toString());

      fire(dragEnd, e);
      _dragStarted = false;
    }
    _dragCanceled = false;
  }

  dom.Element get element => _element;

  void set id(String value) => setAttribute(ID, value);

  String get id => getAttribute(ID);

  num get x => getAttribute(X, 0);

  num get y => getAttribute(Y, 0);

  void set width(num value) => setAttribute(WIDTH, value);

  num get width => getAttribute(WIDTH);

  void set height(num value) => setAttribute(HEIGHT, value);

  num get height => getAttribute(HEIGHT);

  void set scaleX(num x) {
    var oldValue = _transformMatrix.scaleX;
    _transformMatrix.scaleX = x;

    if (oldValue != x) {
      _updatePointerPositionXFromScaleXChange(x, oldValue);
      fire(scaleXChanged, x, oldValue);
    }
  }

  void set scaleY(num y) {
    var oldValue = _transformMatrix.scaleY;
    _transformMatrix.scaleY = y;

    if (oldValue != y) {
      _updatePointerPositionYFromScaleYChange(y, oldValue);
      fire(scaleYChanged, y, oldValue);
    }
  }

  num get scaleX => _transformMatrix.scaleX;
  num get scaleY => _transformMatrix.scaleY;

  void scale(num sx, num sy) {
    var oldSx = _transformMatrix.scaleX;
    var oldSy = _transformMatrix.scaleY;

    _transformMatrix.scaleX = sx;
    _transformMatrix.scaleY = sy;

    bool changed = false;
    if (oldSx != sx) {
      _updatePointerPositionXFromScaleXChange(sx, oldSx);
      changed = true;
    }

    if (oldSy != sy) {
      _updatePointerPositionYFromScaleYChange(sy, oldSy);
      changed = true;
    }

    if (changed) {
      fire(scaleChanged, sx, sy, oldSx, oldSy);
    }
  }

  void set translateX(num tx) {
    var oldValue = _transformMatrix.translateX;
    _transformMatrix.translateX = tx;

    if (oldValue != tx) {
      _updatePointerPositionXFromTranslateXChange(tx, oldValue);
      fire(translateXChanged, tx, oldValue);
    }
  }

  num get translateX => _transformMatrix.translateX;

  void set translateY(num ty) {
    var oldValue = _transformMatrix.translateY;
    _transformMatrix.translateY = ty;

    if (oldValue != ty) {
      _updatePointerPositionYFromTranslateYChange(ty, oldValue);
      fire(translateYChanged, ty, oldValue);
    }
  }

  num get translateY => _transformMatrix.translateY;

  void translate(num tx, num ty) {
    var oldTx = _transformMatrix.translateX;
    var oldTy = _transformMatrix.translateY;

    _transformMatrix.translateX = tx;
    _transformMatrix.translateY = ty;

    bool changed = false;

    if (oldTx != tx) {
      _updatePointerPositionXFromTranslateXChange(tx, oldTx);
      changed = true;
    }

    if (oldTy != ty) {
      _updatePointerPositionYFromTranslateYChange(ty, oldTy);
      changed = true;
    }

    if (changed) {
      fire(translateChanged, tx, ty, oldTx, oldTy);
    }
  }

  dom.Element get container => _container;

  void set isDraggable(bool value) => setAttribute(DRAGGABLE, value);

  bool get isDraggable => getAttribute(DRAGGABLE, false);

  bool get isDragging => _dragging;

  static Stream<String> get onLocationChange =>
      _locationChangedStreamController.stream;

  static String get location {
    var loc = dom.window.location.toString();
    if (loc.contains('#')) {
      loc = loc.substring(0, loc.indexOf('#'));
    }
    return loc;
  }

  static void set location(String value) {
    // remove hash
    if (value.contains('#')) {
      value = value.substring(0, value.indexOf('#'));
    }

    if (value != _preLocation) {
      _preLocation = value;
      _locationChangedStreamController.add(value);
    }
  }
}
