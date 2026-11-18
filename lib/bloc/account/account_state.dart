import '../../domain/entities/archive_request.dart';
import '../../domain/entities/image_request.dart';

sealed class AccountState {}

class AccountLoadInProgress extends AccountState {}

class AccountLoadSuccess extends AccountState {
  final List<ImageRequest> imageRequests;
  final List<ArchiveRequest> archiveRequests;

  AccountLoadSuccess({
    required this.imageRequests,
    required this.archiveRequests,
  });
}

class AccountLoadFailure extends AccountState {
  final String message;
  AccountLoadFailure(this.message);
}
