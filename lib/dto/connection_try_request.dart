class ConnectionTryRequest {
  final String key;

  ConnectionTryRequest({required this.key});

  Map<String, dynamic> toJson() {
    return {'key': key};
  }
}
