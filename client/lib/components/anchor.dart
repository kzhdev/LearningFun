part of LearningFun;

class Anchor extends CharFrame {

  String _char = null;
  Charactor _answer = null;

  Anchor(this._char): super() {
    this.addChild(new Line({
      X1: 0,
      Y1: CHAR_SIZE - 2,
      X2: CHAR_SIZE,
      Y2: CHAR_SIZE - 2,
      STROKE: 'lightgray',
      STROKE_WIDTH: 4
    }));
  }

  void set answer(Charactor char) { _answer = char; }
  Charactor get answer => _answer;

  String get char => _char;
}