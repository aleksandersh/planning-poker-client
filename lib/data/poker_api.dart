import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:planningpoker/data/poker_api_exception.dart';
import 'package:planningpoker/domain/poker_state.dart';

class PokerApi {
  final Uri _host;
  final http.Client _client;

  PokerApi(this._host, this._client);

  Future<String> createRoom() async {
    final url = _createUrl("/v1/rooms");
    final response = await _client.post(url);
    _checkForSuccessResponse(response, "Failed to create room");
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return json['room_id'] as String;
  }

  Future<String> getSession(String roomId) async {
    final url = _createUrl("/v1/rooms/$roomId/players");
    final response = await _client.post(url);
    _checkForSuccessResponse(response, "Failed to create player");
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return json['access_token'] as String;
  }

  Future<PokerRoom?> getRoom(
      String session, String roomId, String? commit) async {
    final Map<String, dynamic> params = {};
    if (commit != null) {
      params['commit'] = commit;
    }
    final url = _createUrl("/v1/rooms/$roomId", params);
    final response =
        await _client.get(url, headers: {'Authorization': session});
    if (response.statusCode == HttpStatus.notModified) {
      return null;
    }
    _checkForSuccessResponse(response, "Failed to get room");
    return _parseRoom(response.body);
  }

  Future sendScore(String session, String roomId, int score) async {
    final url = _createUrl("/v1/rooms/$roomId/currentgame/cards");
    final body = jsonEncode(<String, dynamic>{'score': score});
    final response =
        await _client.put(url, headers: {'Authorization': session}, body: body);
    _checkForSuccessResponse(response, "Failed to send score");
  }

  PokerRoom _parseRoom(String body) {
    final json = jsonDecode(body) as Map<String, dynamic>;

    final playerId = json['player_id'] as String;
    final commit = json['commit'] as String;

    final currentGameJson = json['current_game'] as Map<String, dynamic>;
    final currentGame = _parseCurrentGame(currentGameJson, playerId);

    final playersJson = json['players'] as List;
    final players = playersJson.map((element) {
      final object = element as Map<String, dynamic>;
      return _parsePlayer(object, playerId);
    }).toList();

    final gamesJson = json['games'] as List;
    final games = gamesJson.map((element) {
      final object = element as Map<String, dynamic>;
      return _parseGame(object);
    }).toList();

    return PokerRoom(
      commit,
      currentGame,
      players,
      games,
    );
  }

  PokerCurrentGame _parseCurrentGame(
      Map<String, dynamic> json, String playerId) {
    final name = json['name'] as String? ?? "";
    final link = json['link'] as String? ?? "";
    final status = json['status'] as String? ?? "";
    final suggestedEstimate = json['suggested_estimate'] as int? ?? 0;
    final averageEstimate = json['average_estimate'] as int? ?? 0;
    final isCardsRevealed = json['is_cards_revealed'] as bool? ?? false;

    final cardsJson = json['cards'] as List;
    final cards = cardsJson.map((element) {
      final object = element as Map<String, dynamic>;
      return _parseCard(object, playerId);
    }).toList();

    return PokerCurrentGame(name, link, status, suggestedEstimate,
        averageEstimate, isCardsRevealed, cards);
  }

  PokerPlayer _parsePlayer(Map<String, dynamic> json, String playerId) {
    final id = json['id'] as String;
    final name = json['name'] as String;
    var colorHex = json['color'] as String;
    if (colorHex.length == 6) {
      colorHex = "FF$colorHex";
    }
    final color = int.parse(colorHex, radix: 16);
    final isCurrent = id == playerId;
    final player = PokerPlayer(id, name, color, isCurrent);
    return player;
  }

  PokerGame _parseGame(Map<String, dynamic> json) {
    final id = json['id'] as String;
    final name = json['name'] as String? ?? "";
    final score = json['score'] as int? ?? 0;
    return PokerGame(id, name, score);
  }

  PokerCard _parseCard(Map<String, dynamic> json, String currentPlayerId) {
    final playerJson = json['player'] as Map<String, dynamic>;
    final player = _parsePlayer(playerJson, currentPlayerId);
    final score = json['score'] as int;
    return PokerCard(player, score);
  }

  Uri _createUrl(String path, [Map<String, dynamic>? queryParameters]) {
    return _host.replace(
        path: _host.path + path, queryParameters: queryParameters);
  }

  _checkForSuccessResponse(http.Response response, String message) {
    if (!_isSuccess(response)) {
      switch (response.statusCode) {
        case HttpStatus.unauthorized:
          throw PokerAuthException(message, response.request?.url);
        case HttpStatus.notFound:
          throw ResourceNotFoundException(message, response.request?.url);
        default:
          throw http.ClientException(message, response.request?.url);
      }
    }
  }

  bool _isSuccess(http.Response response) {
    final code = response.statusCode;
    return 200 <= code && code < 300;
  }
}
