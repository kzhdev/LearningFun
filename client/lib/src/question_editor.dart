@HtmlImport('question_editor.html')
library LearningFun.questionEditor;

import 'dart:html' as dom;
import 'package:polymer/polymer.dart';
import 'package:core_elements/core_input.dart';
import 'package:core_elements/core_selector.dart';
import 'package:LearningFun/src/utils/question_lib.dart';

/// Used in template
import 'package:core_elements/core_toolbar.dart';
import 'package:core_elements/core_splitter.dart';
import 'package:paper_elements/paper_input_decorator.dart';
import 'package:paper_elements/paper_item.dart';
import 'package:paper_elements/paper_button.dart';
import 'package:paper_elements/paper_icon_button.dart';

@CustomTag('question-editor')
class QuestionEditor extends PolymerElement {

  @published
  String get lib => readValue(#lib);
  void set lib(String value) => writeValue(#lib, value);

  @published
  String get libPath => readValue(#libPath);
  void set libPath(String value) => writeValue(#libPath, value);

  @published
  String get description => readValue(#description);
  void set description(String value) => writeValue(#description, value);

  @published
  String get viewer => readValue(#viewer);
  void set viewer(String value) => writeValue(#viewer, value);

  @observable
  List questions = toObservable([]);

  dom.Element _preView;
  CoreSelector _questSelector;
  dom.DivElement _preViewContainer;
  CoreInput _input;

  var editingQuestion;

  QuestionEditor.created(): super.created();

  @override
  void attached() {
    getQuestionList('http://localhost:3000/${libPath}')
      .then((questionList) {
      questions.addAll(questionList);
    });

    _questSelector = $['question-selector'];
    _preViewContainer = $['preview-container'];
    _input = $['input'];

    _preView = new dom.Element.tag(viewer);
    _preView.style.height = '${_preViewContainer.clientHeight}px';
    _preView.setAttribute('isPreview', 'true');
    _preViewContainer.children.add(_preView);
  }

  void onQuestionSelected() {
    var index = _questSelector.selectedIndex;
    if (index >= 0 && index < questions.length) {
      editingQuestion = questions[index];

      enableInput();
      _input.value = editingQuestion['text'];
      _input.commit();

      _setPreviewQuestion(editingQuestion['text']);
    }
  }

  void OnInputChanged(event, detail, target) {
    if (editingQuestion == null) {
      editingQuestion = {
        'text': _input.committedValue,
      };
    }
    _setPreviewQuestion(_input.committedValue);
  }

  void _setPreviewQuestion(question) {
    _preView.dispatchEvent(new dom.CustomEvent('set-question',
            detail: question));
  }

  void enableInput() {
    _input.attributes.remove('disabled');
    _input.focus();
    _setPreviewQuestion('');
  }

  void save(e) {
    if (editingQuestion != null) {
      if (editingQuestion.containsKey('_id')) {

      } else {
        postQuestion('http://localhost:3000/${libPath}', editingQuestion)
          .then((e) {
          getQuestionList('http://localhost:3000/${libPath}')
            .then((questionList) {
            questions = toObservable(questionList);
          });
        });
      }
    }
  }

  void delete(e) {
    var index = _questSelector.selectedIndex;
    if (index < questions.length) {
      var question = questions[index];

      _input.value = null;
      _input.commit();

      deleteQuestion('http://localhost:3000/${libPath}', question['_id'])
        .then((e) {
        getQuestionList('http://localhost:3000/${libPath}')
          .then((questionList) {
          questions = toObservable(questionList);
        });

      });
    }
  }
}