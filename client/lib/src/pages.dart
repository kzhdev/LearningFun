library LearningFun.pages;

import 'package:route_hierarchical/client.dart';
export 'package:route_hierarchical/client.dart';

final Router router = new Router(useFragment: true);

class Page {

  final String name;
  final String path;
  final String title;
  final String tag;
  final String description;
  final bool isDefault;
  final bool isQuestion;
  Map attributes = {};


  Page(this.name, this.path, this.title,
      this.tag, {this.description: '',
      this.isDefault: false, this.isQuestion: true});
}

final pages = [
  new Page('home', '', 'Learning Fun', 'home-page', isDefault: true, isQuestion: false),
  new Page('question_editor', 'editor', 'Question Editor', 'question-editor', isQuestion: false),
  new Page('sentence_builder', 'sbs', '造句', 'sentence-builder', description: '请输入句子'),
  new Page('place_missing_word', 'pmw', '填空', 'place-missing-word',
      description: '请输入句子。要填入的词用扣号扣起来。例如：见到好朋友我很（高兴）')
];
