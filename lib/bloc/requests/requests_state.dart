enum RequestKind { image, archive }

class UserNotice {
  final String message;
  final bool isError;

  /// Для какого режима запрос успешно сохранён (null для ошибок).
  final RequestKind? successFor;

  UserNotice(this.message, {this.isError = false, this.successFor});
}

class RequestsState {
  final bool isSubmitting;
  final UserNotice? notice;

  const RequestsState({this.isSubmitting = false, this.notice});
}
