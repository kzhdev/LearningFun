@HtmlImport('place_missing_words.html')
library LearningFun.PlaceMissingWords;

import 'dart:html' as dom;
import 'dart:math';
import 'package:polymer/polymer.dart';
import 'package:smartcanvas/smartcanvas.dart';
import 'package:LearningFun/src/components/char_frame.dart';

// Used in template
import 'package:paper_elements/paper_input_decorator.dart';
import 'package:LearningFun/src/banner.dart';

@CustomTag('place-missing-words')
class PlaceMissingWords extends PolymerElement {

  Stage _stage;

  @observable
  String sentence = '老师（开车）去学校/做饭 游泳 唱歌';

  String label = 'Input a sentence, put anwser in () and noise after /. For example: 老师（开车）去学校／做法 游泳 唱歌:';

  List<Anchor> _anchors = [];
  List<Charactor> _charactors = [];
  List<CharFrame> _parts = [];

  num _margin = 30;

  var _rand = new Random();

  PlaceMissingWords.created() : super.created();

  @override
  void attached() {
    super.attached();

    initPage();
    setSentence();
  }

  void initPage() {
    var container = this.shadowRoot.querySelector('#canvas');
    _stage = new Stage(container, config: {
      WIDTH: container.clientWidth,
      HEIGHT: container.clientHeight - 10
    });

    dom.window.onResize.listen((dom.Event event) {
        event.preventDefault();
        _stage.width = container.clientWidth;
        _stage.height = container.clientHeight - 10;

        _arrangeParts();
    }).resume();
  }

  void clear() {
    _parts.forEach((p) {
      p.remove();
    });
    _anchors.clear();
    _parts.clear();

    _charactors.forEach((c) {
      c.remove();
    });
    _charactors.clear();
  }

  void setSentence() {
    if (sentence != null) {
      clear();
      bool isAnchor = false;
      bool anchorEnd = false;

      var parts = sentence.split('/');
      String sentence_ = parts[0];
      var noise = parts[1].split(' ');
      num i = 0;
      String part;

      while (i != -1 && i < sentence_.length) {
        sentence_ = sentence_.substring(i);

        if (sentence_.startsWith('（') || sentence_.startsWith('(')) {
          i = sentence_.startsWith('（') ? sentence_.indexOf('）') : sentence_.indexOf(')');
          part = sentence_.substring(1, i);
          ++i;
          isAnchor = true;
        } else {
          i = sentence_.indexOf('（');
          if (i != -1) {
            part = sentence_.substring(0, i);
          } else {
            part = sentence_;
          }

          isAnchor = false;
        }

        if (isAnchor) {
          _createAnchor(part);
          _createCharactor(part);
        } else {
          var c = new Charactor(part, asAnchor: true);
          _parts.add(c);
          _stage.addChild(c);
        }
      }

//      for (var i = 0; i < sentence.length; i++) {
//        var c = sentence[i];
//
//        if (c.startsWith('(') || c.startsWith('（')) {
//          isAnchor = true;
//          c = c.substring(1);
//        }
//
//        if (c.endsWith('(') || c.endsWith('（')) {
//          c = c.substring(0, c.length - 2);
//          anchorEnd = true;
//        }
//
//        var part;
//        if (isAnchor) {
//          _createAnchor(c);
//          _createCharactor(c);
//        } else {
//          part = new Charactor(c, asAnchor: true);
//          _parts.add(part);
//          _stage.addChild(part);
//        }
//
//        if (anchorEnd) {
//          isAnchor = false;
//          anchorEnd = true;
//        }
//      }
      _arrangeParts();

      for (var i = 0; i < noise.length; i++) {
        var c = noise[i];
        _createCharactor(c);
      }
    }
  }

  void _createAnchor(String char) {
    var anchor = new Anchor(char);
    if (char == ' ') {
      anchor.visible = false;
    }
    _anchors.add(anchor);
    _parts.add(anchor);
    _stage.addChild(anchor);
  }

  void _createCharactor(String c) {
    var char = new Charactor(c);
    char..x = _rand.nextInt(_stage.width - 50)
        ..y = _rand.nextInt(_stage.height - 100);

    if (c == ' ') {
      char.visible = false;
    }

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
            this.fire('core-signal', detail: {'name': 'show-banner', 'data': {'success': false}});
            break;
          case 1:
            this.fire('core-signal', detail: {'name': 'show-banner', 'data': {'success': true}});
            break;
        }

      } else {
        if (char.anchor != null) {
          char.anchor.answer = null;
          char.anchor = null;
        }
      }
    });
    _charactors.add(char);
    _stage.addChild(char);
  }

  void _arrangeParts() {
    var space = 5;
    var len = _parts.length;
    var nCharPerRow = ((_stage.width - _margin * 2) / (CHAR_SIZE + space)).floor();
    var numRows = (len / nCharPerRow).ceil();
    var width, left, top;

    if (len <= nCharPerRow) {
      width = CHAR_SIZE * len + space * (len - 1);
    } else {
      width = CHAR_SIZE * nCharPerRow + space * (nCharPerRow - 1);
    }

    left = (_stage.width - width) / 2;
    top = _stage.height - _margin - numRows * CHAR_SIZE - (numRows - 1) * space;

    var offsetX = left;
    var offsetY = top;

    for (var i = 0; i < len; i++) {
      var part = _parts[i];
      part.x = offsetX;
      part.y = offsetY;

      if (part is Anchor && part.answer != null) {
        part.answer.x = offsetX;
        part.answer.y = offsetY;
      }

      if ((i + 1) % nCharPerRow == 0) {
        offsetX = left;
        offsetY += CHAR_SIZE + space;
      } else {
        offsetX += CHAR_SIZE + space;
      }
    }
  }

  Anchor _getOverlapAnchor(Charactor char) {
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

  void _dockToAnchor(Charactor char, Anchor anchor) {
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

  void OnInputChange(event, detail, target) {
    sentence = target.committedValue;

    setSentence();
    target.value = null;
    target.commit();
  }

  void OnBannerClosed(event, detail, target) {
    if (_checkAnswer() == 1) {
      clear();
      sentence = null;
    }
  }
}
