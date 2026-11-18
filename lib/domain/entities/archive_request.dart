import 'package:cloud_firestore/cloud_firestore.dart';

import 'geo_rect.dart';

/// Запрос режима 2: поиск в открытых базах (пока заглушка).
class ArchiveRequest {
  final String id;
  final String description;
  final GeoRect coordinates;
  final DateTime periodFrom;
  final DateTime periodTo;
  final DateTime? createdAt;

  const ArchiveRequest({
    this.id = '',
    required this.description,
    required this.coordinates,
    required this.periodFrom,
    required this.periodTo,
    this.createdAt,
  });

  factory ArchiveRequest.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return ArchiveRequest(
      id: doc.id,
      description: data['description'] as String? ?? '',
      coordinates: GeoRect.fromMap(data['coordinates'] as Map<String, dynamic>),
      periodFrom: (data['periodFrom'] as Timestamp).toDate(),
      periodTo: (data['periodTo'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    'description': description,
    'coordinates': coordinates.toMap(),
    'periodFrom': Timestamp.fromDate(periodFrom),
    'periodTo': Timestamp.fromDate(periodTo),
  };
}
