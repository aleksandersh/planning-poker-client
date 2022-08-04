import 'package:http/http.dart' as http;
import 'package:planningpoker/app_config.dart';
import 'package:planningpoker/data/poker_api.dart';
import 'package:planningpoker/data/poker_repository.dart';
import 'package:planningpoker/view/app/router.dart';
import 'package:planningpoker/view/entry/state_model.dart';
import 'package:planningpoker/view/room/state_model.dart';

class AppDependencies {
  final PokerRepository _pokerRepository;

  factory AppDependencies() {
    final httpClient = http.Client();
    final pokerApi = PokerApi(AppConfig.host, httpClient);
    final pokerRepository = PokerRepository(pokerApi);
    return AppDependencies._internal(pokerRepository);
  }

  AppDependencies._internal(this._pokerRepository);

  EntryStateModel createEntryStateModel(AppRouter appRouter) {
    return EntryStateModel(appRouter, _pokerRepository);
  }

  RoomStateModel createRoomStateModel(String roomId, AppRouter appRouter) {
    return RoomStateModel(roomId, appRouter, _pokerRepository);
  }
}
