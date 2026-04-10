class HttpApiException {
  String errorTitle;
  String errorSuggestion;
  int errorCode;

  HttpApiException({
    required this.errorCode,
    this.errorSuggestion = "Please try again later!",
    this.errorTitle = "Unexpected error!",
  });
}
