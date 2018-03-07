import 'package:playground/src/sentence_builder.dart';
import 'package:playground/src/components/bus.dart';

void main() {

  var bus = new Bus();

  var sentenceBuilder = new SentenceBuilder("playground");
//  sentenceBuilder.setSentence("我爱学中文");

  bus.on('resize', () => sentenceBuilder.resize());
  bus.on('clear-workspace', () => sentenceBuilder.setSentence(null));
  bus.on('setSentence', (sentence) => sentenceBuilder.setSentence(sentence));

}