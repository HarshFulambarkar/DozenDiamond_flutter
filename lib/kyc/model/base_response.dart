
import 'error_response.dart';

class BaseResponse<T> {
  ErrorResponse? error;
  T? data;

  setException(ErrorResponse error) {
    this.error = error;
  }

  @override
  String toString() {
    return 'BaseModel{error: $error, data: $data}';
  }

  setData(T data) {
    this.data = data;
  }

  get getException {
    return error;
  }
}