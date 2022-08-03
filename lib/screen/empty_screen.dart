import 'package:flutter/material.dart';
import 'package:planningpoker/poker_theme.dart';

class EmptyScreenWidget extends StatelessWidget {
  const EmptyScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: gameColorBackground,
      body: Center(
        child: Text(
          "Available only by invites, stay tuned!",
          style: TextStyle(
            color: gameColorText1,
            fontWeight: FontWeight.w500,
            fontSize: 48,
          ),
        ),
      ),
    );
  }
}
