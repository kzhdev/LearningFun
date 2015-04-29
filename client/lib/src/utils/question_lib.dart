library questionlib;

import 'dart:math';
import 'dart:html' show HttpRequest, FormData;
import 'dart:convert';
import 'dart:async';

const String question = 'question';
const String familarity = 'familarity';

final Random rand = new Random((new DateTime.now()).millisecondsSinceEpoch);

Future getQuestionList(String path) {
  var completer = new Completer();
  HttpRequest.request(path)
    .then((HttpRequest req) {
    completer.complete(JSON.decode(req.response));
  }, onError: (e) {
    completer.completeError(e);
  });
  return completer.future;
}

Future getQuestion (String path, String id) {
  var completer = new Completer();
  HttpRequest.request('$path/$id')
    .then((HttpRequest req) {
    completer.complete(JSON.decode(req.response));
  }, onError: (e) {
    completer.completeError(e);
  });
  return completer.future;
}

Future postQuestion(String path, Map question) {
  var completer = new Completer();
  HttpRequest.request(
      path, method: 'POST',
      sendData: JSON.encode(question),
      requestHeaders: {'Content-Type': 'application/json'})
    .then((HttpRequest req) {
    completer.complete(JSON.decode(req.response));
  }, onError: (e) {
    completer.completeError(e);
  });
  return completer.future;
}

Future updateQuestion(String path, Map question) {
  var completer = new Completer();

  HttpRequest.request(
      path, method: 'PUT',
      sendData: JSON.encode(question),
      requestHeaders: {'Content-Type': 'application/json'})
    .then((HttpRequest req) {
    completer.complete(JSON.decode(req.response));
  }, onError: (e) {
    completer.completeError(e);
  });
  return completer.future;
}

Future deleteQuestion(String path, String id) {
  var completer = new Completer();
  HttpRequest.request('$path/$id', method: 'DELETE')
    .then((HttpRequest req) {
    completer.complete(JSON.decode(req.response));
  }, onError: (e) {
    completer.completeError(e);
  });
  return completer.future;
}
