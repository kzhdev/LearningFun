part of canvas;

enum AnimLoopStatus {
  started,
  stopped,
}

class AnimationLoopSubscriber {
  final String id;
  final bool repeat;
  final Function callback;

  AnimationLoopSubscriber(this.id, this.repeat, this.callback);
}

class AnimationLoop {

  static AnimationLoop _instance = null;

  AnimLoopStatus _loopStatus = AnimLoopStatus.stopped;
  bool _inAnimFrame = false;

  final Map<String, AnimationLoopSubscriber> _subscribers = {};
  final Map<String, AnimationLoopSubscriber> _pendingAddSubscribers = {};
  final Set<String> _pendingRemoveSubscribers = new Set<String>();

  factory AnimationLoop() {
    if (_instance == null) {
      _instance = new AnimationLoop._internal();
    }
    return _instance;
  }

  AnimationLoop._internal();

  void _start() {
    if (_loopStatus != AnimLoopStatus.started) {
      _loopStatus = AnimLoopStatus.started;
      dom.window.animationFrame.then(onAnimationFrame);
    }
  }

  void _stop() {
    _loopStatus = AnimLoopStatus.stopped;
  }

  void onAnimationFrame(num timestamp) {
    for (var id in _pendingRemoveSubscribers) {
      _subscribers.remove(id);
    }
    _pendingRemoveSubscribers.clear();

    if (_subscribers.isEmpty) {
      _stop();
      return;
    }

    if (_loopStatus == AnimLoopStatus.started) {

      bool repeat = false;
      List<AnimationLoopSubscriber> oneTimeSubscribers = [];
      _inAnimFrame = true;

      for (AnimationLoopSubscriber subscriber in _subscribers.values) {
        subscriber.callback(timestamp);

        if (subscriber.repeat) {
          repeat = true;
        } else {
          oneTimeSubscribers.add(subscriber);
        }
      };

      _inAnimFrame = false;

      for (AnimationLoopSubscriber subscriber in oneTimeSubscribers) {
        unsubscribe(subscriber.id);
      }

      if (repeat) {
        dom.window.animationFrame.then(onAnimationFrame);
      }

      _pendingAddSubscribers.forEach((String id, AnimationLoopSubscriber subscriber) {
        _subscribers[id] = subscriber;
      });
    }
  }

  void subscribe(String id, Function callback, {bool repeat: true}) {
    if (_subscribers.isEmpty) {
      _start();
    }

    if (_inAnimFrame) {
      _pendingAddSubscribers[id] = new AnimationLoopSubscriber(id, repeat, callback);
    } else {
      _subscribers[id] = new AnimationLoopSubscriber(id, repeat, callback);
    }
  }

  void unsubscribe(String id) {
    if (_inAnimFrame) {
      _pendingRemoveSubscribers.add(id);
    } else {
      _subscribers.remove(id);
    }

    if (_subscribers.isEmpty) {
      _stop();
    }
  }
}
