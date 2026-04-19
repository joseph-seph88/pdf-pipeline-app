class ApiResponse<T> {
  final int statusCode;
  final String statusType;
  final T? data;

  ApiResponse({required this.statusCode, required this.statusType, this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromData,
  ) {
    final rawData = json['data'];

    return ApiResponse<T>(
      statusCode: json['status_code'] as int,
      statusType: json['status_type'] as String,
      data: rawData != null ? fromData(rawData) : null,
    );
  }
}
