class PokerRoom {
  final bool isOwner;
  final String? commit;
  final PokerCurrentGame currentGame;
  final List<PokerPlayer> players;
  final List<PokerGame> games;

  PokerRoom(
      this.isOwner, this.commit, this.currentGame, this.players, this.games);
}

class PokerCurrentGame {
  final String name;
  final String link;
  final String status;
  final int suggestedEstimate;
  final int averageEstimate;
  final bool isCardsRevealed;
  final List<PokerCard> cards;

  PokerCurrentGame(this.name, this.link, this.status, this.suggestedEstimate,
      this.averageEstimate, this.isCardsRevealed, this.cards);
}

class PokerPlayer {
  final String id;
  final String name;
  final int color;
  final bool isCurrent;

  PokerPlayer(this.id, this.name, this.color, this.isCurrent);
}

class PokerGame {
  final String id;
  final String name;
  final int score;

  PokerGame(this.id, this.name, this.score);
}

class PokerCard {
  final PokerPlayer player;
  final int score;

  PokerCard(this.player, this.score);
}
