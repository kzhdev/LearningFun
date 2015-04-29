part of LearningFun;

class Charactor extends CharFrame {

  Anchor _anchor = null;

  Text _text = new Text({
    FONT_SIZE: 50,
    Y: 48,
  });

  Charactor(String char, {bool asAnchor: false}): super() {
    _text.text = char;

    _text.x = (CHAR_SIZE - _text.width) / 2;

    this.addChild(_text);

    if (!asAnchor) {

      this.draggable = true;

      this.on(MOUSEENTER, (){
        String userAgent = dom.window.navigator.userAgent.toLowerCase();
        if (userAgent.contains('applewebkit')) {
          dom.document.body.style.cursor = '-webkit-grab';
        } else if (userAgent.contains('firefox')) {
          dom.document.body.style.cursor = '-moz-grab';
        } else {
          dom.document.body.style.cursor = 'move';
        }
      });

      this.on(MOUSEOUT, (){
        dom.document.body.style.cursor = 'default';
      });

      this.on(MOUSEDOWN, () {
        this.moveToTop();
        String userAgent = dom.window.navigator.userAgent.toLowerCase();
        if (userAgent.contains('applewebkit')) {
          dom.document.body.style.cursor = '-webkit-grabbing';
        } else if (userAgent.contains('firefox')) {
          dom.document.body.style.cursor = '-moz-grabbing';
        } else {
          dom.document.body.style.cursor = 'move';
        }
      });

      this.on(MOUSEUP, () {
        String userAgent = dom.window.navigator.userAgent.toLowerCase();
        if (userAgent.contains('applewebkit')) {
          dom.document.body.style.cursor = '-webkit-grab';
        } else if (userAgent.contains('firefox')) {
          dom.document.body.style.cursor = '-moz-grab';
        } else {
          dom.document.body.style.cursor = 'move';
        }
      });

      this.on(DRAGSTART, (){
        this.moveToTop();
      });
    }
  }

  void set anchor(Anchor value) { _anchor = value; }
  Anchor get anchor => _anchor;

  String get text => _text.text;
}