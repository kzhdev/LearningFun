@HtmlImport('home.html')
library LearningFun.home;

import 'package:polymer/polymer.dart';
import 'package:LearningFun/src/pages.dart' as config;

@CustomTag('home-page')
class HomePage extends PolymerElement {

  @observable
  List pages = toObservable(config.pages);

  HomePage.created(): super.created();

  void goto(event, detail, target) {
    config.router.go(target.id, {});
  }
}