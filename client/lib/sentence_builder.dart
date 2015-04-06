@HtmlImport('sentence_builder.html')
library LearningFun.sentenceBuilder;

import 'dart:html' as dom;
import 'dart:convert';
import 'dart:math';
import 'package:polymer/polymer.dart';
import 'package:smartcanvas/smartcanvas.dart';
import 'package:LearningFun/components/char_frame.dart';
import 'package:core_elements/core_input.dart';

import 'package:paper_elements/paper_input_decorator.dart';
import 'package:LearningFun/banner.dart';

@CustomTag('sentence-builder')
class SentenceBuilder extends PolymerElement {

  Stage _stage;

  static QuestionLib _questions = new QuestionLib('sentence-builder');

  @observable
  String sentence = null;

  List<Anchor> _anchors = [];
  List<Charactor> _charactors = [];

  num _margin = 30;

  var _rand = new Random();

  SentenceBuilder.created() : super.created();

  @override
  void attached() {
    initPage();
    setSentence();
  }

  void initPage() {
    var container = this.shadowRoot.querySelector('#canvas');
    _stage = new Stage(container, 'svg', {
      WIDTH: container.clientWidth,
      HEIGHT: container.clientHeight - 10
    });

    dom.window.onResize.listen((dom.Event event) {
        event.preventDefault();
        _stage.width = container.clientWidth;
        _stage.height = container.clientHeight - 10;

        _arrangeAnchors();
    }).resume();
  }

  void clear() {
    _anchors.forEach((anchor) {
      anchor.remove();
    });
    _anchors.clear();
    _charactors.forEach((char) {
      char.remove();
    });
    _charactors.clear();
  }

  void setSentence([String sent = null]) {
    if (sent == null) {
      if (_questions.isNotEmpty) {
        if (_questions.length > 1) {
          sentence = _questions.next[question];
        } else {
          sentence = _questions[0][question];
        }
      }
    } else {
      sentence = sent;
    }

    if (sentence != null) {
      clear();
      _createAnchors();
      _createCharactors();
      _arrangeAnchors();
    }
  }

  void _createAnchors() {
    for (var i = 0; i < sentence.length; i++) {
      var anchor = new Anchor(sentence[i]);
      if (sentence[i] == ' ') {
        anchor.visible = false;
      }
      _anchors.add(anchor);
      _stage.addChild(anchor);
    }
  }

  void _createCharactors() {
    for (var i = 0; i < sentence.length; i++) {
      if (sentence[i] == ' ') {
        continue;
      }
      var char = new Charactor(sentence[i]);
      char..x = _rand.nextInt(_stage.width - 50)
          ..y = _rand.nextInt(_stage.height - 100);

      char.on(DRAGEND, (){
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
  }

  void _arrangeAnchors() {
    var space = 5;
    var len = _anchors.length;
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
    var sent = target.committedValue;

    _questions.add({question: sent, familarity: 0});

    setSentence(sent);

    target.value = null;
    target.commit();
  }

  void OnBannerClosed(event, detail, target) {
    if (_checkAnswer() == 1) {
      clear();
      sentence = _questions.next[question];
    }
  }
}
