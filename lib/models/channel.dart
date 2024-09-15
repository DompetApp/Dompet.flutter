class ChannelResult {
  final String status;
  final String? message;
  final dynamic result;

  ChannelResult({
    required this.status,
    this.message,
    this.result,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'result': result,
    };
  }

  factory ChannelResult.fromJson(Map<String, dynamic> json) {
    return ChannelResult(
      status: json['status'],
      message: json['message'],
      result: json['result'],
    );
  }

  factory ChannelResult.failure({String? message, dynamic result}) {
    return ChannelResult(
      status: 'failure',
      message: message,
      result: result,
    );
  }

  factory ChannelResult.success({String? message, dynamic result}) {
    return ChannelResult(
      status: 'success',
      message: message,
      result: result,
    );
  }
}
