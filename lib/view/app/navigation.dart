import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:planningpoker/dependencies.dart';
import 'package:planningpoker/view/app/router.dart';
import 'package:planningpoker/view/entry/entry_widget.dart';
import 'package:planningpoker/view/room/widget.dart';
import 'package:provider/provider.dart';

abstract class AppPath {}

class EntryPath extends AppPath {}

class RoomPath extends AppPath {
  String roomId;

  RoomPath(this.roomId);
}

const _pathSegmentRooms = 'rooms';

class AppRouteParser extends RouteInformationParser<AppPath> {
  @override
  Future<AppPath> parseRouteInformation(RouteInformation routeInformation) {
    final location = routeInformation.location;
    if (location == null) {
      return SynchronousFuture(EntryPath());
    }
    final uri = Uri.parse(location);
    if (uri.pathSegments.length > 1 &&
        uri.pathSegments[0] == _pathSegmentRooms) {
      final roomId = uri.pathSegments[1];
      return SynchronousFuture(RoomPath(roomId));
    }
    return SynchronousFuture(EntryPath());
  }

  @override
  RouteInformation? restoreRouteInformation(AppPath configuration) {
    if (configuration is RoomPath) {
      return RouteInformation(
          location: '/$_pathSegmentRooms/${configuration.roomId}');
    }
    if (configuration is EntryPath) {
      return const RouteInformation(location: '/');
    }
    return null;
  }
}

class AppRouterDelegate extends RouterDelegate<AppPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppPath>
    implements AppRouter {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  AppPath get currentConfiguration => _currentPath;

  final AppDependencies _dependencies = AppDependencies();
  AppPath _currentPath = EntryPath();

  @override
  Widget build(BuildContext context) {
    final path = _currentPath;
    return Navigator(
      key: navigatorKey,
      pages: [
        if (path is RoomPath)
          MaterialPage(
              key: const ValueKey('Room'),
              child: ChangeNotifierProvider(
                  create: (context) {
                    final model =
                        _dependencies.createRoomStateModel(path.roomId, this);
                    model.onCreate();
                    return model;
                  },
                  child: const RoomScreenWidget()))
        else
          MaterialPage(
            key: const ValueKey('Entry'),
            child: ChangeNotifierProvider(
                create: (context) {
                  return _dependencies.createEntryStateModel(this);
                },
                child: const EntryScreenWidget()),
          )
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        if (_currentPath is RoomPath) {
          _currentPath = EntryPath();
          notifyListeners();
        }
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppPath configuration) {
    _currentPath = configuration;
    return SynchronousFuture(null);
  }

  @override
  void showEntry() {
    _currentPath = EntryPath();
    notifyListeners();
  }

  @override
  void showRoom(String roomId) {
    _currentPath = RoomPath(roomId);
    notifyListeners();
  }

  @override
  Future<bool> popRoute() {
    return SynchronousFuture(_currentPath is EntryPath);
  }
}
