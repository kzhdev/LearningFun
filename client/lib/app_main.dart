@HtmlImport('app_main.html')
library LearningFun.appMain;

import 'package:polymer/polymer.dart';
// used in template
import 'package:core_elements/core_header_panel.dart';
import 'package:core_elements/core_toolbar.dart';
import 'package:core_elements/core_label.dart';
import 'package:LearningFun/sentence_builder.dart/';
import 'package:LearningFun/word_builder.dart';
import 'package:LearningFun/place_missing_words.dart';

@CustomTag('app-main')
class AppMain extends PolymerElement {

  @observable
  String get route => readValue(#route);
  void set route(String value) =>writeValue(#route, value);

  @observable
  String get title => readValue(#title);
  void set title(String value) => writeValue(#title, value);

  AppMain.created(): super.created() {
    route = 'home';
    title = 'Learning Fun';
  }

  void goto(event, detail, target) {
    route = target.id;
    switch (route) {
      case 'home':
        title = 'Learning Fun';
        break;
      case 'sentence-builder':
        title = 'Sentence Builder';
        break;
      case 'place-missing-words':
        title = 'Place Missing Words';
        break;
      case 'word-builder':
        title = 'Word Builder';
        break;
    }
  }

  void edit(event, detail, target) {

  }
}