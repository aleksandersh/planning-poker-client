import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:planningpoker/app_config.dart';
import 'package:planningpoker/data/poker_api.dart';
import 'package:planningpoker/data/poker_api_exception.dart';
import 'package:planningpoker/data/poker_repository.dart';
import 'package:planningpoker/domain/poker_state.dart';

PokerRoom _createInitialState() {
  return PokerRoom(
    null,
    PokerCurrentGame(
      "",
      "",
      "",
      0,
      0,
      false,
      [],
    ),
    [],
    [],
  );
}

class RoomStateModel extends ChangeNotifier {
  PokerRoom state = _createInitialState();

  final String _roomId;
  final String? _playerName;

  final http.Client _httpClient;
  final PokerRepository _pokerRepository;

  bool _isDisposed = false;

  factory RoomStateModel(roomId, playerName) {
    final httpClient = http.Client();
    final pokerApi = PokerApi(AppConfig.host, httpClient);
    final pokerRepository = PokerRepository(pokerApi);
    return RoomStateModel._internal(
      roomId,
      playerName,
      httpClient,
      pokerRepository,
    );
  }

  RoomStateModel._internal(
      this._roomId, this._playerName, this._httpClient, this._pokerRepository);

  @override
  void dispose() {
    super.dispose();
    _disposeClient();
  }

  onCreate() {
    _observeRoom();
  }

  onClickScore(int score) async {
    try {
      await _sendScore(score);
    } on ResourceNotFoundException {
      _disposeClient();
    } catch (error) {
      log("Failed to send score", error: error);
    }
  }

  _observeRoom() async {
    while (!_isDisposed) {
      await _refreshRoom();
      await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
    }
  }

  _refreshRoom() async {
    try {
      final room =
          await _pokerRepository.getRoom(_roomId, _playerName, state.commit);
      if (room != null) {
        state = room;
        notifyListeners();
      }
    } on ResourceNotFoundException {
      _disposeClient();
    } catch (error) {
      log("Failed to get room", error: error);
    }
  }

  Future _sendScore(int score) async {
    await _pokerRepository.sendScore(_roomId, _playerName, score);
  }

  _disposeClient() {
    _httpClient.close();
    _isDisposed = true;
  }
}
