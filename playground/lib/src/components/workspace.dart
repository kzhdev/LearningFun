import 'package:canvas_lib/canvas_lib.dart';
import 'dart:html' as dom;

class Workspace {
  dom.DivElement _container;

  Canvas _canvas;

  Workspace(String container_id) {
    if (!container_id.startsWith('#')) {
      container_id = "#" + container_id;
    }

    _container = dom.querySelector(container_id);
    _canvas = new Canvas(_container);

    dom.window.onResize.listen((dom.Event event) {
      event.preventDefault();
      resize();
    }).resume();
  }

  void resize() {
    _canvas.width = _container.clientWidth;
    _canvas.height = _container.clientHeight - 10;
  }

  void addElement(Node node) {
    _canvas.addChild(node);
  }

  void clear() {
    _canvas.clearChildren();
  }

  num get width => _canvas.width;
  num get height => _canvas.height;
}