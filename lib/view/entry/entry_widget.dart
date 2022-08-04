import 'package:flutter/material.dart';
import 'package:planningpoker/poker_theme.dart';
import 'package:planningpoker/view/entry/state_model.dart';
import 'package:provider/provider.dart';

class EntryScreenWidget extends StatelessWidget {
  const EntryScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: gameColorBackground,
        body: Center(child: createRoomCreationCard(context)));
  }

  Widget createRoomCreationCard(BuildContext context) {
    final model = Provider.of<EntryStateModel>(context, listen: false);
    return Container(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Card(
        elevation: 16,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: pokerColorCard,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(
                  left: 20, top: 20, right: 20, bottom: 10),
              child: const Text(
                "New poker room",
                style: TextStyle(
                  color: pokerColor1,
                  fontSize: 24,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 20, top: 18, right: 20, bottom: 24),
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  model.onClickCreateRoom();
                },
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: pokerColor1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6))),
                child: const Text("CREATE"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
