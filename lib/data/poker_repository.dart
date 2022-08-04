import 'dart:async';

import 'package:planningpoker/data/poker_api.dart';
import 'package:planningpoker/data/poker_api_exception.dart';
import 'package:planningpoker/domain/poker_state.dart';

class PokerRepository {
  final PokerApi _api;
  _RoomSession? _roomSession;

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
    final roomSession = await _getSession(roomId);
    try {
      return action(roomSession.session);
    } on PokerAuthException {
      if (_roomSession == roomSession) {
        _roomSession = null;
      }
      final newRoomSession = await _getSession(roomId);
      return action(newRoomSession.session);
    }
  }

  Future<_RoomSession> _getSession(String roomId) async {
    final roomSession = _roomSession;
    if (roomSession != null && roomSession.roomId == roomId) {
      return roomSession;
    }
    final session = await _createSession(roomId);
    final newRoomSession = _RoomSession(roomId, session);
    _roomSession = newRoomSession;
    return newRoomSession;
  }

  Future<String> _createSession(String roomId) async {
    return _api.getSession(roomId);
  }
}

class _RoomSession {
  String roomId;
  String session;

  _RoomSession(this.roomId, this.session);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _RoomSession &&
          runtimeType == other.runtimeType &&
          roomId == other.roomId &&
          session == other.session;

  @override
  int get hashCode => roomId.hashCode ^ session.hashCode;
}
