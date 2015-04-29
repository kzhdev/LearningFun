@HtmlImport('src/app_main.html')
library LearningFun.appMain;

import 'dart:html' as dom;
import 'package:polymer/polymer.dart';
import 'package:LearningFun/src/pages.dart';

// used in template
import 'package:core_elements/core_header_panel.dart';
import 'package:core_elements/core_toolbar.dart';
import 'package:core_elements/core_label.dart';
import 'package:LearningFun/src/sentence_builder.dart/';
import 'package:LearningFun/src/word_builder.dart';
import 'package:LearningFun/src/place_missing_words.dart';
import 'package:LearningFun/src/home.dart';
import 'package:LearningFun/src/question_editor.dart';

@CustomTag('app-main')
class AppMain extends PolymerElement {

  @observable
  String route = toObservable('home');

  @observable
  var currentPage;

  dom.Element _body;

  AppMain.created(): super.created();

  @override
  void attached() {
    super.attached();
    _body = $['body'];
  }

  domReady() {
    // Set up the routes for all the pages.
    for (var page in pages) {
      router.root.addRoute(
        name: page.name,
        path: page.path,
        enter: enterRoute,
        defaultRoute: page.isDefault
      );
    }
    router.listen();
  }

  void routeChanged(e) {
    if (route is! String) return;

    if (route.isEmpty) {
      currentPage = pages.firstWhere((page) => page.isDefault);
    } else {
      currentPage = pages.firstWhere((page) => page.path == route);
    }
//    router.go(currentPage.name, {});
  }

  void enterRoute(RouteEvent e) {
    route = e.path;
    var page = pages.firstWhere((page) => page.path == route);
    var tag = page.tag;
    if (tag != null) {

      if (tag == 'question-editor' && currentPage == null) {
        router.go('home', {});
      } else {
        var el = new dom.Element.tag(tag);

        if (tag == 'question-editor') {
          el.attributes.addAll({
            'lib': currentPage.title,
            'libPath': currentPage.path,
            'viewer': currentPage.tag,
            'description': currentPage.description
          });
        }

        if (page.attributes.isNotEmpty) {
            el.attributes.addAll(page.attributes);
        }

        _body.children.clear();
        _body.children.add(el);
      }
    }
  }

  void goHome(event, detail, target) {
    router.go('home', {});
  }

  void edit(event, detail, target) {
    if (currentPage.path == 'editor') {
      router.go('home', {});
    } else {
      router.go('question_editor', {});
    }

  }

}