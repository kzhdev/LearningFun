library app_bootstrap;

import 'package:polymer/polymer.dart';

import 'package:polymer/src/build/log_injector.dart';
import 'index.web_components.bootstrap.dart' as i0;
import 'package:smoke/smoke.dart' show Declaration, PROPERTY, METHOD;
import 'package:smoke/static.dart' show useGeneratedCode, StaticConfiguration;
import 'package:polymer/auto_binding.dart' as smoke_0;
import 'package:polymer/polymer.dart' as smoke_1;
import 'package:LearningFun/banner.dart' as smoke_2;
import 'package:observe/src/metadata.dart' as smoke_3;
import 'package:LearningFun/sentence_builder.dart' as smoke_4;
import 'package:LearningFun/word_builder.dart' as smoke_5;
import 'package:LearningFun/place_missing_words.dart' as smoke_6;
import 'package:LearningFun/app_main.dart' as smoke_7;
abstract class _M1 {} // _M0 & Observable
abstract class _M0 {} // Object & Polymer

void main() {
  useGeneratedCode(new StaticConfiguration(
      checkedMode: false,
      getters: {
        #OnBannerClosed: (o) => o.OnBannerClosed,
        #OnInputChange: (o) => o.OnInputChange,
        #close: (o) => o.close,
        #edit: (o) => o.edit,
        #goto: (o) => o.goto,
        #label: (o) => o.label,
        #route: (o) => o.route,
        #sentence: (o) => o.sentence,
        #showBanner: (o) => o.showBanner,
        #text: (o) => o.text,
        #title: (o) => o.title,
      },
      setters: {
        #close: (o, v) { o.close = v; },
        #label: (o, v) { o.label = v; },
        #route: (o, v) { o.route = v; },
        #sentence: (o, v) { o.sentence = v; },
        #text: (o, v) { o.text = v; },
        #title: (o, v) { o.title = v; },
      },
      parents: {
        smoke_7.AppMain: smoke_1.PolymerElement,
        smoke_2.AppBanner: smoke_1.PolymerElement,
        smoke_6.PlaceMissingWords: smoke_1.PolymerElement,
        smoke_4.SentenceBuilder: smoke_1.PolymerElement,
        smoke_5.WordBuilder: smoke_1.PolymerElement,
        smoke_0.AutoBindingElement: _M1,
        _M1: _M0,
      },
      declarations: {
        smoke_7.AppMain: {
          #route: const Declaration(#route, String, kind: PROPERTY, annotations: const [smoke_3.observable]),
          #title: const Declaration(#title, String, kind: PROPERTY, annotations: const [smoke_3.observable]),
        },
        smoke_2.AppBanner: {
          #close: const Declaration(#close, Function, annotations: const [smoke_1.published]),
          #text: const Declaration(#text, String, annotations: const [smoke_3.observable]),
        },
        smoke_6.PlaceMissingWords: {
          #sentence: const Declaration(#sentence, String, annotations: const [smoke_3.observable]),
        },
        smoke_4.SentenceBuilder: {
          #sentence: const Declaration(#sentence, String, annotations: const [smoke_3.observable]),
        },
        smoke_5.WordBuilder: {},
        smoke_0.AutoBindingElement: {},
        smoke_1.PolymerElement: {},
      },
      names: {
        #OnBannerClosed: r'OnBannerClosed',
        #OnInputChange: r'OnInputChange',
        #close: r'close',
        #edit: r'edit',
        #goto: r'goto',
        #label: r'label',
        #route: r'route',
        #sentence: r'sentence',
        #showBanner: r'showBanner',
        #text: r'text',
        #title: r'title',
      }));
  new LogInjector().injectLogsFromUrl('index.html._buildLogs');
  configureForDeployment();
  i0.main();
}
