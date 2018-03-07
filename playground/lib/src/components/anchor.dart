import 'char_frame.dart';
import 'character.dart';
import 'package:canvas_lib/canvas_lib.dart';

class Anchor extends CharFrame {

  String _char = null;
  Character _answer = null;

  Anchor(this._char): super() {
    this.addChild(new Line({
      X1: 0,
      Y1: CHAR_SIZE - 2,
      X2: CHAR_SIZE,
      Y2: CHAR_SIZE - 2,
      STROKE: 'black',
      STROKE_WIDTH: 4
    }));
  }

  void set answer(Character char) { _answer = char; }
  Character get answer => _answer;

  String get char => _char;
}