import 'package:http/http.dart';

class PokerAuthException extends ClientException {
  PokerAuthException(message, [uri]) : super(message, uri);
}

class ResourceNotFoundException extends ClientException {
  ResourceNotFoundException(message, [uri]) : super(message, uri);
}
