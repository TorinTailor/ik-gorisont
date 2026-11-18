import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/requests_repository.dart';
import '../../utils/connectivity.dart';
import '../../utils/error_messages.dart';
import 'requests_event.dart';
import 'requests_state.dart';

class RequestsBloc extends Bloc<RequestsEvent, RequestsState> {
  final RequestsRepository _repository;

  RequestsBloc(this._repository) : super(const RequestsState()) {
    on<ImageRequestSubmitted>(_onImage);
    on<ArchiveRequestSubmitted>(_onArchive);
  }

  Future<void> _onImage(
    ImageRequestSubmitted event,
    Emitter<RequestsState> emit,
  ) {
    return _submit(
      emit,
      () => _repository.addImageRequest(event.request),
      RequestKind.image,
    );
  }

  Future<void> _onArchive(
    ArchiveRequestSubmitted event,
    Emitter<RequestsState> emit,
  ) {
    return _submit(
      emit,
      () => _repository.addArchiveRequest(event.request),
      RequestKind.archive,
    );
  }

  Future<void> _submit(
    Emitter<RequestsState> emit,
    Future<void> Function() action,
    RequestKind kind,
  ) async {
    if (!await hasInternet()) {
      emit(
        RequestsState(
          notice: UserNotice(noInternetActionMessage, isError: true),
        ),
      );
      return;
    }
    emit(const RequestsState(isSubmitting: true));
    try {
      await action();
      emit(
        RequestsState(
          notice: UserNotice('Запрос сохранён', successFor: kind),
        ),
      );
    } catch (e) {
      emit(
        RequestsState(
          notice: UserNotice(
            'Не удалось сохранить запрос. ${errorMessage(e)}',
            isError: true,
          ),
        ),
      );
    }
  }
}
