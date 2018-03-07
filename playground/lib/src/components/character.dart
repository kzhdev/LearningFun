import 'package:canvas_lib/canvas_lib.dart';
import 'char_frame.dart';
import 'anchor.dart';
import 'dart:html' as dom;
import 'dart:math';

class Character extends CharFrame {

  Anchor _anchor = null;

  static final _rand = new Random((new DateTime.now()).millisecondsSinceEpoch);
  static final _colors = [
    'red', 'green', 'blue', 'orange', 'purple'
  ];
  static final _color_count = _colors.length;

  Text _text = new Text({
    FONT_SIZE: 50,
    FILL: _getRandomColor(),
    Y: 48,
  });

  Character(String char, {bool asAnchor: false}): super() {
    _text.text = char;

    _text.x = (CHAR_SIZE - _text.width) / 2;

    this.addChild(_text);

    if (!asAnchor) {

      this.draggable = true;

      this.on(mouseEnter, (){
        String userAgent = dom.window.navigator.userAgent.toLowerCase();
        if (userAgent.contains('applewebkit')) {
          dom.document.body.style.cursor = '-webkit-grab';
        } else if (userAgent.contains('firefox')) {
          dom.document.body.style.cursor = '-moz-grab';
        } else {
          dom.document.body.style.cursor = 'move';
        }
      });

      this.on(mouseOut, (){
        dom.document.body.style.cursor = 'default';
      });

      this.on(mouseDown, () {
        this.moveToTop();
        String userAgent = dom.window.navigator.userAgent.toLowerCase();
        if (userAgent.contains('applewebkit')) {
          dom.document.body.style.cursor = '-webkit-grabbing';
        } else if (userAgent.contains('firefox')) {
          dom.document.body.style.cursor = '-moz-grabbing';
        } else {
          dom.document.body.style.cursor = 'move';
        }
      });

      this.on(mouseUp, () {
        String userAgent = dom.window.navigator.userAgent.toLowerCase();
        if (userAgent.contains('applewebkit')) {
          dom.document.body.style.cursor = '-webkit-grab';
        } else if (userAgent.contains('firefox')) {
          dom.document.body.style.cursor = '-moz-grab';
        } else {
          dom.document.body.style.cursor = 'move';
        }
      });

      this.on(dragStart, (){
        this.moveToTop();
      });
    }
  }

  static String _getRandomColor() {
    var idx = _rand.nextInt(_color_count);
    return idx < _color_count ? _colors[idx] : 'black';
  }

  static String _toHexString(int i) {
    String rt = i.toRadixString(16);
    while (rt.length < 2) {
      rt = '0' + rt;
    }
    return rt;
  }

  void set anchor(Anchor value) { _anchor = value; }
  Anchor get anchor => _anchor;

  String get text => _text.text;
}