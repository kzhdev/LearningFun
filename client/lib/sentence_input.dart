@HtmlImport('sentence_input.html')
library LearningFun.sentenceInput;

import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_dialog.dart';
import 'dart:html';

@CustomTag('sentence-input')
class SentenceInput extends PolymerElement {

  InputElement _input;
  PaperDialog _popup;

  SentenceInput.created(): super.created();

  @override
  void attached() {
    _input = $['input'];
    _popup = $['popup'];
  }

  void OnKeyPress(KeyboardEvent event, detail, target) {
    if (event.keyCode == 13) {
      this.fire('core-signal', detail: {
        'name': 'set-sentence',
        'data': { 'sentence': _input.value }
      });
      _popup.close();
    }
  }
}