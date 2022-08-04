import 'package:flutter/material.dart';
import 'package:planningpoker/domain/poker_state.dart';
import 'package:planningpoker/poker_theme.dart';
import 'package:planningpoker/view/room/state_model.dart';
import 'package:provider/provider.dart';

class RoomScreenWidget extends StatelessWidget {
  const RoomScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gameColorBackground,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            SizedBox(
              height: 240,
              child: _createGameInfoWidget(),
            ),
            SizedBox(
              height: 190,
              child: _createResultContentWidget(),
            ),
            SizedBox(
              height: 140,
              child: _createCardsWidget(context),
            )
          ],
        ),
      ),
    );
  }

  Widget _createGameInfoWidget() => ListView(
        padding: const EdgeInsets.all(20),
        scrollDirection: Axis.horizontal,
        children: [
          _createGameStatusWidget(),
          const SizedBox(width: 20),
          _createGamesListWidget(),
          const SizedBox(width: 20),
          _createPlayersListWidget()
        ],
      );

  Widget _createGameStatusWidget() => SizedBox(
        width: 280,
        height: 200,
        child: Card(
          elevation: 16,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: _createGameStatusContentWidget(),
          ),
        ),
      );

  Widget _createGameStatusContentWidget() => Consumer<RoomStateModel>(
      builder: (context, model, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.state.currentGame.name,
                style: const TextStyle(
                  color: gameColorText1,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "link: ${model.state.currentGame.link}",
                style: const TextStyle(
                  color: pokerColor1,
                  fontSize: 14,
                ),
              ),
              Text(
                "status: ${model.state.currentGame.status}",
                style: const TextStyle(
                  color: gameColorText1,
                  fontSize: 14,
                ),
              ),
              Text(
                "suggested estimate: ${getEstimateView(model.state.currentGame.suggestedEstimate)}",
                style: const TextStyle(
                  color: gameColorText1,
                  fontSize: 14,
                ),
              ),
              Text(
                "average estimate: ${model.state.currentGame.averageEstimate}",
                style: const TextStyle(
                  color: gameColorText1,
                  fontSize: 14,
                ),
              ),
            ],
          ));

  Widget _createGamesListWidget() => SizedBox(
        width: 230,
        height: 200,
        child: Card(
          elevation: 16,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding:
                      EdgeInsets.only(left: 20, top: 20, bottom: 16, right: 20),
                  child: Text(
                    "Games",
                    style: TextStyle(
                      color: gameColorTitle1,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ),
                Expanded(
                  child: _createGamesListContentWidget(),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _createGamesListContentWidget() => Consumer<RoomStateModel>(
      builder: (context, model, child) => ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemBuilder: (context, index) =>
                _createGamesListItemWidget(model.state.games[index]),
            itemCount: model.state.games.length,
          ));

  Widget _createGamesListItemWidget(PokerGame game) => Container(
        padding: const EdgeInsets.only(left: 20, top: 6, right: 20, bottom: 6),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              game.name,
              style: const TextStyle(
                color: gameColorText1,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Text(
              getEstimateView(game.score),
              style: const TextStyle(
                color: gameColorText1,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );

  Widget _createPlayersListWidget() => SizedBox(
        width: 230,
        height: 200,
        child: Card(
          elevation: 16,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding:
                      EdgeInsets.only(left: 20, top: 20, bottom: 16, right: 20),
                  child: Text(
                    "Players",
                    style: TextStyle(
                      color: gameColorTitle1,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ),
                Expanded(
                  child: _createPlayersListContentWidget(),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _createPlayersListContentWidget() => Consumer<RoomStateModel>(
      builder: (context, model, child) => ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemBuilder: (context, index) =>
                createPlayersListItemWidget(model.state.players[index]),
            itemCount: model.state.players.length,
          ));

  Widget createPlayersListItemWidget(PokerPlayer player) => IntrinsicHeight(
        child: Container(
          color: player.isCurrent ? gameColorCurrentPlayer : null,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 12,
                color: Color(player.color),
              ),
              Container(
                color: player.isCurrent ? gameColorCurrentPlayer : null,
                padding: const EdgeInsets.only(
                    left: 20, top: 6, right: 20, bottom: 6),
                child: Text(
                  player.name,
                  style: const TextStyle(
                    color: gameColorText1,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _createResultContentWidget() => Consumer<RoomStateModel>(
      builder: (context, model, child) => ListView.builder(
            padding: const EdgeInsets.only(left: 20, right: 20),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => _createResultCardWidget(
              model.state.currentGame.cards[index],
              model.state.currentGame.isCardsRevealed,
            ),
            itemCount: model.state.currentGame.cards.length,
          ));

  Widget _createResultCardWidget(PokerCard card, bool isRevealed) => Container(
        width: 160,
        height: 190,
        padding:
            const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 16,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      card.player.name,
                      style: const TextStyle(
                        color: gameColorText1,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    isRevealed ? getEstimateView(card.score) : "",
                    style: const TextStyle(
                      color: gameColorText1,
                      fontSize: 48,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Color(card.player.color),
                    height: 12,
                    // width: 12,
                  ),
                )
              ],
            ),
          ),
        ),
      );

  Widget _createCardsWidget(BuildContext context) {
    final model = Provider.of<RoomStateModel>(context, listen: false);
    return ListView(
      padding: const EdgeInsets.only(left: 10, right: 10),
      scrollDirection: Axis.horizontal,
      children: [
        _createCardWidget(model, 0),
        _createCardWidget(model, 1),
        _createCardWidget(model, 2),
        _createCardWidget(model, 3),
        _createCardWidget(model, 5),
        _createCardWidget(model, 8),
        _createCardWidget(model, 13),
        _createCardWidget(model, 21),
        _createCardWidget(model, 34),
        _createCardWidget(model, -1),
        _createCardWidget(model, -2),
      ],
    );
  }

  Widget _createCardWidget(RoomStateModel model, int score) => Container(
        width: 88,
        height: 140,
        padding: const EdgeInsets.only(left: 4, top: 20, right: 4, bottom: 20),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 4,
          child: InkWell(
            onTap: () => model.onClickScore(score),
            borderRadius: BorderRadius.circular(8),
            child: Center(
              child: Text(
                getEstimateView(score),
                style: const TextStyle(
                  color: gameColorText1,
                  fontWeight: FontWeight.w500,
                  fontSize: 42,
                ),
              ),
            ),
          ),
        ),
      );

  String getEstimateView(int estimate) {
    if (estimate >= 0) {
      return estimate.toString();
    } else if (estimate == -1) {
      return "?";
    } else {
      return "*";
    }
  }
}
