@HtmlImport('rating.html')
library LearningFun.rating;

import 'package:polymer/polymer.dart';
import 'package:core_elements/core_icons.dart';

@CustomTag('rating-element')
class RatingElement extends PolymerElement {

  @published
  int get maxRate => readValue(#maxRate);
  void set maxRate(int value) => writeValue(#maxRate, value);

  @observable
  List<int> range = toObservable([]);

  int _currentRating = 0;

  RatingElement.created() : super.created();

  @ObserveProperty('maxRate')
  void updateRange() {
    range = toObservable(new List<int>.generate(maxRate, (int index) => index + 1));
  }

  void updateRating(e) {
    var index = int.parse(e.target.id);

    if (index > _currentRating) {

    }
  }
}