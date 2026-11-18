import '../../domain/entities/archive_request.dart';
import '../../domain/entities/image_request.dart';

sealed class AccountEvent {}

class AccountStarted extends AccountEvent {}

class AccountImagesChanged extends AccountEvent {
  final List<ImageRequest> requests;
  AccountImagesChanged(this.requests);
}

class AccountArchivesChanged extends AccountEvent {
  final List<ArchiveRequest> requests;
  AccountArchivesChanged(this.requests);
}

class AccountStreamFailed extends AccountEvent {
  final Object error;
  AccountStreamFailed(this.error);
}
