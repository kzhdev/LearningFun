import 'package:canvas_lib/canvas_lib.dart';

num CHAR_SIZE = 60;

class CharFrame extends Group {

//  Rect _border = new Rect({
//    WIDTH: _CHAR_SIZE,
//    HEIGHT: _CHAR_SIZE,
//    RX: 6,
//    RY: 6,
//    STROKE: 'black',
//    FILL: 'white',
//  });

  CharFrame(): super({WIDTH: CHAR_SIZE, HEIGHT: CHAR_SIZE}) {
//    this.addChild(_border);
  }
}