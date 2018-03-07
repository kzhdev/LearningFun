import './components/anchor.dart';
import './components/character.dart';
import './components/workspace.dart';
import './components/bus.dart';
import './components/char_frame.dart' show CHAR_SIZE;
import 'package:canvas_lib/canvas_lib.dart' show Position, dragEnd, Layer;
import 'dart:math';

class SentenceBuilder extends Workspace
{
  List<Anchor> _anchors = [];
  List<Character> _characters = [];

  String _sentence;

  num _margin = 30;
  var _rand = new Random();
  var _bus = new Bus();
  var _layer = new Layer({'id': 'sentenceBuilder'});

  SentenceBuilder(String container_id): super(container_id) {
    addElement(_layer);
  }

  @override
  void resize() {
    super.resize();
    if (_sentence != null) {
      _arrangeAnchors();
    }
  }

  void setSentence(String sentence) {
    _sentence = sentence;
    _anchors.clear();
    _characters.clear();
    _layer.clearChildren();

    if (_sentence != null) {
      _createAnchors();
      _createCharacters();
      _arrangeAnchors();
    }
  }

  void _createAnchors() {
    for (var i = 0; i < _sentence.length; i++) {
      var anchor = new Anchor(_sentence[i]);
      if (_sentence[i] == ' ') {
        anchor.visible = false;
      }
      _anchors.add(anchor);
      _layer.addChild(anchor);
    }
  }

  void _createCharacters() {
    var charPoss = [];

    bool isOverlap(num x, num y) {
      for (var pos in charPoss) {
        if (x >= pos.x - 10 && x <= pos.x + 60 &&
            y >= pos.y - 10 && y <= pos.y + 60) {
          return true;
        }
      }
      return false;
    }

    for (var i = 0; i < _sentence.length; i++) {
      if (_sentence[i] == ' ') {
        continue;
      }
      var char = new Character(_sentence[i]);
      var x, y;

      do {
        x = _rand.nextInt(width - 100);
        y = _rand.nextInt(height - 200);
      } while(isOverlap(x, y));

      char..x = x
        ..y = y;

      charPoss.add(new Position(x: x, y: y));

      char.on(dragEnd, (){
        var anchor = _getOverlapAnchor(char);
        if (anchor != null) {
          if (char.anchor != null &&
              char.anchor != anchor) {
            char.anchor.answer = null;
            char.anchor = null;
          }

          _dockToAnchor(char, anchor);

          switch(_checkAnswer()) {
            case -1:
              _bus.fire('wksMsg', 'showBanner', false);
              break;
            case 1:
              _bus.fire('wksMsg', 'showBanner', true);
              break;
          }

        } else {
          if (char.anchor != null) {
            char.anchor.answer = null;
            char.anchor = null;
          }
        }
      });
      _characters.add(char);
      _layer.addChild(char);
    }
  }

  Anchor _getOverlapAnchor(Character char) {
    for (var i = 0; i < _anchors.length; i++) {
      var anchor = _anchors[i];
      var charCX = char.x + CHAR_SIZE / 2;
      var charCY = char.y + CHAR_SIZE / 2;
      if (charCX > anchor.x - 5 &&
          charCX < anchor.x + CHAR_SIZE + 5 &&
          charCY > anchor.y - 5 &&
          charCY < anchor.y + CHAR_SIZE + 5) {
        return anchor;
      }
    }
    return null;
  }

  void _dockToAnchor(Character char, Anchor anchor) {
    if (anchor.answer == null ||
        anchor.answer == char) {
      char.x = anchor.x;
      char.y = anchor.y;
      anchor.answer = char;
      char.anchor = anchor;
    }
  }

  int _checkAnswer() {
    bool hasError = false;

    for(var i = 0; i < _anchors.length; i++) {
      var anchor = _anchors[i];
      if (anchor.answer == null &&
          anchor.char != " ") {
        return 0;
      }

      if (anchor.char != " " &&
          anchor.char != anchor.answer.text) {
        hasError = true;
      }
    }

    return hasError ? -1 : 1;
  }

  void _arrangeAnchors() {
    var space = 5;
    var len = _anchors.length;
    var nCharPerRow = ((width - _margin * 2) / (CHAR_SIZE + space)).floor();
    var numRows = (len / nCharPerRow).ceil();
    var w, left, top;

    if (len <= nCharPerRow) {
      w = CHAR_SIZE * len + space * (len - 1);
    } else {
      w = CHAR_SIZE * nCharPerRow + space * (nCharPerRow - 1);
    }

    left = (width - w) / 2;
    top = height - _margin - numRows * CHAR_SIZE - (numRows - 1) * space;

//    print("_arrangeAnchors")

    var offsetX = left;
    var offsetY = top;

    for (var i = 0; i < len; i++) {
      var anchor = _anchors[i];
      anchor.x = offsetX;
      anchor.y = offsetY;

      if (anchor.answer != null) {
        anchor.answer.x = offsetX;
        anchor.answer.y = offsetY;
      }

      if ((i + 1) % nCharPerRow == 0) {
        offsetX = left;
        offsetY += CHAR_SIZE + space;
      } else {
        offsetX += CHAR_SIZE + space;
      }
    }
  }
}