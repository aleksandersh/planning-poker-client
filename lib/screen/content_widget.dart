import 'package:flutter/material.dart';
import 'package:planningpoker/poker_theme.dart';

class ContentWidget extends StatelessWidget {
  const ContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: createRoomCreationCard());
  }

  Widget createRoomCreationCard() {
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
                  left: 20, top: 10, right: 20, bottom: 10),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    borderSide: BorderSide(color: pokerColorLightGray),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 20, top: 10, right: 20, bottom: 10),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "Room password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    borderSide: BorderSide(color: pokerColorLightGray),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 20, top: 18, right: 20, bottom: 24),
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
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
