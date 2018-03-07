import 'package:canvas_lib/event_bus.dart';
import 'package:jsproxy/jsproxy.dart';

class Bus
{
  static Bus _impl = null;
  final EventBus _bus = new EventBus();

  factory Bus() {
    if (_impl == null) {
      _impl = new Bus._instance();
    }
    return _impl;
  }

  Bus._instance() {

    var bus = context['bus'] = new JsObject(jsObject, []);

    bus['on'] = (String event, JsFunction method, [String id]) {
      void handler([arg0, arg1, arg2, arg3, arg4, arg5]) {
        List args = [arg0, arg1, arg2, arg3, arg4, arg5].map((arg) {
          return createJsProxy(arg);
        }).toList();

        // remove trailing null from the list;
        while (args.isNotEmpty) {
          if (args.last == null) {
            args.removeAt(args.length - 1);
          } else {
            break;
          }
        }

        try {
          method.apply(args);
        } catch(e) {
          print("event $event handler threw exception: $e");
        }
      }
      _bus.on(event, handler, id);
      // allow chaining
      return bus;
    };

    bus['off'] = _bus.off;
    bus['fire'] = _bus.fire;
  }

  void on(events, Function handler, [String id]) => _bus.on(events, handler, id);
  void off(events, [String id]) => _bus.off(events, id);
  void fire(String event, [dynamic arg0, arg1, arg2, arg3, arg4, arg5]) =>
      _bus.fire(event, arg0, arg1, arg2, arg3, arg4, arg5);
}