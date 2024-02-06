class ApiError implements Exception {
  ApiError(
      {required this.message,
      required this.date,
      required this.generatedBy,
      this.statusCode});

  ApiError.fromJson(Map<String, dynamic> json) {
    message = json['message'] as String;
    date = json['date'] as String;
    generatedBy = json['generatedBy'] as String;
  }
  late String message;
  late String date;
  late String generatedBy;
  // The http status code (if available)
  int? statusCode;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['message'] = message;
    data['date'] = date;
    data['generatedBy'] = generatedBy;
    return data;
  }

  @override
  String toString() => "$date '$message' Source: $generatedBy";
}
