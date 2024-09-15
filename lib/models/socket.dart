class SocketMeta {
  final String type;
  final dynamic data;

  SocketMeta({
    required this.type,
    this.data,
  });

  SocketMeta clone({String? type, dynamic data}) {
    return SocketMeta(
      type: type ?? this.type,
      data: data ?? this.data,
    );
  }

  factory SocketMeta.clone({required type, dynamic data}) {
    return SocketMeta(
      type: type,
      data: data,
    );
  }
}
