typedef SocketCallback = void Function(String type, dynamic data);

class SocketSubscribe {
  final String type;
  final SocketCallback callback;

  SocketSubscribe({required this.type, required this.callback});

  factory SocketSubscribe.fromJson(Map<String, dynamic> json) {
    return SocketSubscribe(type: json['type'], callback: json['callback']);
  }
}
