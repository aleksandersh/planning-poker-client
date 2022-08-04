import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:planningpoker/data/poker_repository.dart';
import 'package:planningpoker/view/app/router.dart';

class EntryState {
  final bool isLoading;

  EntryState(this.isLoading);
}

class EntryStateModel extends ChangeNotifier {
  final AppRouter _appRouter;
  final PokerRepository _pokerRepository;
  EntryState state = EntryState(false);
  bool _isDisposed = false;

  EntryStateModel(this._appRouter, this._pokerRepository);

  onClickCreateRoom() {
    _createRoom();
  }

  @override
  void dispose() {
    super.dispose();
    _isDisposed = true;
  }

  _createRoom() async {
    if (!_isDisposed && !state.isLoading) {
      state = EntryState(true);
      notifyListeners();
      try {
        final roomId = await _pokerRepository.createRoom();
        _appRouter.showRoom(roomId);
      } catch (error) {
        state = EntryState(false);
        log("Failed to create room", error: error);
      }
    }
  }
}
