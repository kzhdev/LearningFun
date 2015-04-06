part of LearningFun;

const String question = 'question';
const String familarity = 'familarity';

class QuestionLib {

  static Random rand = new Random((new DateTime.now()).millisecondsSinceEpoch);

  List<Map> _questions;
  int currentIndex = -1;
  final String type;

  QuestionLib(this.type) {
    if (dom.window.localStorage.containsKey(type) == false) {
      dom.window.localStorage[type] = JSON.encode([]);
    }
    _questions = JSON.decode(dom.window.localStorage[type]);
  }

  List<Map> get qestions => _questions;

  Map get next {
    if (_questions.isEmpty) {
      return null;
    }

    if (_questions.length == 1) {
      return _questions[0];
    }

    int nextIndex;
    do {
      nextIndex = rand.nextInt(_questions.length);
    } while(nextIndex == currentIndex);

    currentIndex = nextIndex;
    return _questions[currentIndex];
  }

  void add(Map question) {
    _questions.add(question);
    dom.window.localStorage[type] = JSON.encode(_questions);
  }

  void remove(Map question) {
    _questions.remove(question);
    dom.window.localStorage[type] = JSON.encode(_questions);
  }

  int get length => _questions.length;

  bool get isEmpty => _questions.isEmpty;

  bool get isNotEmpty => _questions.isNotEmpty;

  Map operator[] (int index) => _questions[index];

  Map get first => _questions.first;

  Map get last => _questions.last;
}