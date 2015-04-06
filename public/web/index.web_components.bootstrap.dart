import 'package:initialize/src/static_loader.dart';
import 'package:initialize/initialize.dart';
import 'index.bootstrap.dart' as i0;
import 'package:polymer/polymer.dart' as i1;
import 'package:web_components/html_import_annotation.dart' as i2;
import 'package:core_elements/core_header_panel.dart' as i3;
import 'package:web_components/custom_element_proxy.dart' as i4;
import 'package:core_elements/core_toolbar.dart' as i5;
import 'package:core_elements/core_label.dart' as i6;
import 'package:core_elements/core_input.dart' as i7;
import 'package:core_elements/core_meta.dart' as i8;
import 'package:core_elements/core_iconset.dart' as i9;
import 'package:core_elements/core_icon.dart' as i10;
import 'package:core_elements/core_iconset_svg.dart' as i11;
import 'package:core_elements/core_icons.dart' as i12;
import 'package:core_elements/core_style.dart' as i13;
import 'package:paper_elements/paper_input_decorator.dart' as i14;
import 'package:core_elements/core_transition.dart' as i15;
import 'package:core_elements/core_resizable.dart' as i16;
import 'package:core_elements/core_key_helper.dart' as i17;
import 'package:core_elements/core_overlay_layer.dart' as i18;
import 'package:core_elements/core_overlay.dart' as i19;
import 'package:core_elements/core_transition_css.dart' as i20;
import 'package:paper_elements/paper_dialog_base.dart' as i21;
import 'package:paper_elements/paper_shadow.dart' as i22;
import 'package:paper_elements/paper_action_dialog.dart' as i23;
import 'package:core_elements/core_signals.dart' as i24;
import 'package:LearningFun/banner.dart' as i25;
import 'package:LearningFun/sentence_builder.dart' as i26;
import 'package:LearningFun/word_builder.dart' as i27;
import 'package:LearningFun/place_missing_words.dart' as i28;
import 'package:LearningFun/app_main.dart' as i29;

main() {
  initializers.addAll([
    new InitEntry(
        const i4.CustomElementProxy('core-header-panel'), i3.CoreHeaderPanel),
    new InitEntry(const i4.CustomElementProxy('core-toolbar'), i5.CoreToolbar),
    new InitEntry(const i4.CustomElementProxy('core-label'), i6.CoreLabel),
    new InitEntry(
        const i4.CustomElementProxy('core-input', extendsTag: 'input'),
        i7.CoreInput),
    new InitEntry(const i4.CustomElementProxy('core-meta'), i8.CoreMeta),
    new InitEntry(const i4.CustomElementProxy('core-iconset'), i9.CoreIconset),
    new InitEntry(const i4.CustomElementProxy('core-icon'), i10.CoreIcon),
    new InitEntry(
        const i4.CustomElementProxy('core-iconset-svg'), i11.CoreIconsetSvg),
    new InitEntry(const i4.CustomElementProxy('core-style'), i13.CoreStyle),
    new InitEntry(const i4.CustomElementProxy('paper-input-decorator'),
        i14.PaperInputDecorator),
    new InitEntry(
        const i4.CustomElementProxy('core-transition'), i15.CoreTransition),
    new InitEntry(
        const i4.CustomElementProxy('core-key-helper'), i17.CoreKeyHelper),
    new InitEntry(const i4.CustomElementProxy('core-overlay-layer'),
        i18.CoreOverlayLayer),
    new InitEntry(const i4.CustomElementProxy('core-overlay'), i19.CoreOverlay),
    new InitEntry(const i4.CustomElementProxy('core-transition-css'),
        i20.CoreTransitionCss),
    new InitEntry(
        const i4.CustomElementProxy('paper-dialog-base'), i21.PaperDialogBase),
    new InitEntry(const i4.CustomElementProxy('paper-shadow'), i22.PaperShadow),
    new InitEntry(const i4.CustomElementProxy('paper-action-dialog'),
        i23.PaperActionDialog),
    new InitEntry(const i4.CustomElementProxy('core-signals'), i24.CoreSignals),
    new InitEntry(const i1.CustomTag('app-banner'), i25.AppBanner),
    new InitEntry(const i1.CustomTag('sentence-builder'), i26.SentenceBuilder),
    new InitEntry(const i1.CustomTag('word-builder'), i27.WordBuilder),
    new InitEntry(
        const i1.CustomTag('place-missing-words'), i28.PlaceMissingWords),
    new InitEntry(const i1.CustomTag('app-main'), i29.AppMain),
  ]);

  i0.main();
}
