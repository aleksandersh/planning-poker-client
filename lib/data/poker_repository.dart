import 'dart:async';

import 'package:planningpoker/data/poker_api.dart';
import 'package:planningpoker/data/poker_api_exception.dart';
import 'package:planningpoker/domain/poker_state.dart';

class PokerRepository {
  final PokerApi _api;
  String? _session;

  PokerRepository(this._api);

  Future createRoom() async {
    return _api.createRoom();
  }

  Future<PokerRoom?> getRoom(String roomId, String? commit) async {
    return withSession(
        roomId, (session) => _api.getRoom(session, roomId, commit));
  }

  Future sendScore(String roomId, int score) async {
    return withSession(
        roomId, (session) => _api.sendScore(session, roomId, score));
  }

  Future showCards(String roomId) async {
    return withSession(roomId, (session) => _api.showCards(session, roomId));
  }

  Future resetGame(String roomId) async {
    return withSession(roomId, (session) => _api.resetGame(session, roomId));
  }

  Future startNextGame(String roomId) async {
    return withSession(
        roomId, (session) => _api.startNextGame(session, roomId));
  }

  Future<T> withSession<T>(
      String roomId, Future<T> Function(String session) action) async {
    final session = await _getSession(roomId);
    try {
      return action(session);
    } on PokerAuthException {
      if (_session == session) {
        _session = null;
      }
      final newSession = await _getSession(roomId);
      return action(newSession);
    }
  }

  Future<String> _getSession(String roomId) async {
    var session = _session;
    if (session == null) {
      session = await _createSession(roomId);
      _session = session;
    }
    return session;
  }

  Future<String> _createSession(String roomId) async {
    return _api.getSession(roomId);
  }
}
