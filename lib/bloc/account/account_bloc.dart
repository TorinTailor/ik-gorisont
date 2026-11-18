import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/requests_repository.dart';
import '../../domain/entities/archive_request.dart';
import '../../domain/entities/image_request.dart';
import '../../utils/connectivity.dart';
import '../../utils/error_messages.dart';
import 'account_event.dart';
import 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final RequestsRepository _repository;

  StreamSubscription<List<ImageRequest>>? _imagesSub;
  StreamSubscription<List<ArchiveRequest>>? _archivesSub;
  List<ImageRequest>? _images;
  List<ArchiveRequest>? _archives;

  AccountBloc(this._repository) : super(AccountLoadInProgress()) {
    on<AccountStarted>(_onStarted);
    on<AccountImagesChanged>((event, emit) {
      _images = event.requests;
      _emitIfReady(emit);
    });
    on<AccountArchivesChanged>((event, emit) {
      _archives = event.requests;
      _emitIfReady(emit);
    });
    on<AccountStreamFailed>((event, emit) {
      emit(
        AccountLoadFailure(
          'Не удалось загрузить заказы.\n${errorMessage(event.error)}',
        ),
      );
    });
  }

  void _emitIfReady(Emitter<AccountState> emit) {
    final images = _images;
    final archives = _archives;
    if (images == null || archives == null) return;
    emit(AccountLoadSuccess(imageRequests: images, archiveRequests: archives));
  }

  Future<void> _onStarted(
    AccountStarted event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoadInProgress());
    await _imagesSub?.cancel();
    await _archivesSub?.cancel();
    _images = null;
    _archives = null;

    if (!await hasInternet()) {
      emit(
        AccountLoadFailure('Не удалось загрузить заказы.\n$noInternetMessage'),
      );
      return;
    }

    _imagesSub = _repository.watchImageRequests().listen(
      (requests) => add(AccountImagesChanged(requests)),
      onError: (Object error) => add(AccountStreamFailed(error)),
    );
    _archivesSub = _repository.watchArchiveRequests().listen(
      (requests) => add(AccountArchivesChanged(requests)),
      onError: (Object error) => add(AccountStreamFailed(error)),
    );
  }

  @override
  Future<void> close() async {
    await _imagesSub?.cancel();
    await _archivesSub?.cancel();
    return super.close();
  }
}
