@HtmlImport('banner.html')
library LearningFun.banner;

import "package:polymer/polymer.dart";
import "package:paper_elements/paper_action_dialog.dart";
/// used in template
import 'package:core_elements/core_signals.dart';

@CustomTag("app-banner")
class AppBanner extends PolymerElement {

  @observable
  String text = '';

  @published
  Function close = null;

  PaperActionDialog _popup;
  AppBanner.created(): super.created();

  @override
  void attached() {
    super.attached();
    _popup = $['popup'];
  }

  void showBanner(event, details, target) {
    text = details['success'] == true ? "Great Job!" : "Try Again!";
    _popup.open();
  }

  void OnClose(event, detail, target) {
    if (close != null) {
      close();
    }
  }
}