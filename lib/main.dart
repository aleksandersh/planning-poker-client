import 'package:flutter/material.dart';
import 'package:planningpoker/room_state_model.dart';
import 'package:planningpoker/screen/empty_screen.dart';
import 'package:planningpoker/screen/room_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sscrum poker',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      onGenerateRoute: generateRoute,
    );
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    var name = settings.name;
    if (name != null) {
      final url = Uri.parse(name);
      if (url.pathSegments.length == 2 && url.pathSegments[0] == "rooms") {
        final roomId = url.pathSegments[1];
        final playerName = url.queryParameters['name'];
        return MaterialPageRoute(
          maintainState: false,
          builder: (context) {
            return ChangeNotifierProvider(
              create: (context) {
                final model = RoomStateModel(roomId, playerName);
                model.onCreate();
                return model;
              },
              child: const RoomScreenWidget(),
            );
          },
        );
      }
    }
    return MaterialPageRoute(builder: (context) => const EmptyScreenWidget());
  }
}
