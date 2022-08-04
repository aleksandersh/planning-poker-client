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
    final session = await _getSession(roomId);
    try {
      return await _api.getRoom(session, roomId, commit);
    } on PokerAuthException {
      if (_session == session) {
        _session = null;
      }
      final newSession = await _getSession(roomId);
      return await _api.getRoom(newSession, roomId, commit);
    }
  }

  Future sendScore(String roomId, int score) async {
    final session = await _getSession(roomId);
    try {
      return _api.sendScore(session, roomId, score);
    } on PokerAuthException {
      if (_session == session) {
        _session = null;
      }
      final newSession = await _getSession(roomId);
      return _api.sendScore(newSession, roomId, score);
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
