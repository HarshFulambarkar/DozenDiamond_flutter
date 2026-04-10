class ErrorResponse {
  ErrorResponse({this.message, this.status, this.errors});

  String? message;
  bool? status = false;
  Map? errors;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
      message: json["message"],
      status: json['success'] == null ? false : json['success'],
      errors: json["errors"] == null ? null : json["errors"]);

  Map<String, dynamic> toJson() => {"message": message, "success": status};
}
