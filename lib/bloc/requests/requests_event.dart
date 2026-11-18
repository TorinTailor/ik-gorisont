import '../../domain/entities/archive_request.dart';
import '../../domain/entities/image_request.dart';

sealed class RequestsEvent {}

class ImageRequestSubmitted extends RequestsEvent {
  final ImageRequest request;
  ImageRequestSubmitted(this.request);
}

class ArchiveRequestSubmitted extends RequestsEvent {
  final ArchiveRequest request;
  ArchiveRequestSubmitted(this.request);
}
