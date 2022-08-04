import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:planningpoker/data/poker_api_exception.dart';
import 'package:planningpoker/data/poker_repository.dart';
import 'package:planningpoker/domain/poker_state.dart';
import 'package:planningpoker/view/app/router.dart';

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
  final String _roomId;
  final AppRouter _appRouter;
  final PokerRepository _pokerRepository;

  PokerRoom state = _createInitialState();
  bool _isDisposed = false;

  RoomStateModel(this._roomId, this._appRouter, this._pokerRepository);

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
      final room = await _pokerRepository.getRoom(_roomId, state.commit);
      if (room != null) {
        state = room;
        notifyListeners();
      }
    } on ResourceNotFoundException {
      _appRouter.showEntry();
      _disposeClient();
    } catch (error) {
      log("Failed to get room", error: error);
    }
  }

  Future _sendScore(int score) async {
    await _pokerRepository.sendScore(_roomId, score);
  }

  _disposeClient() {
    _isDisposed = true;
  }
}
