import 'package:cloud_firestore/cloud_firestore.dart';

import 'geo_rect.dart';

/// Запрос режима 1: пользователь «загрузил» снимок.
/// Сам файл нигде не хранится, сохраняются только текстовые данные.
class ImageRequest {
  final String id;
  final String title;
  final String fileName;
  final String description;
  final GeoRect? coordinates;
  final DateTime? shotAt;
  final DateTime? createdAt;

  const ImageRequest({
    this.id = '',
    required this.title,
    required this.fileName,
    required this.description,
    this.coordinates,
    this.shotAt,
    this.createdAt,
  });

  factory ImageRequest.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    final coordinates = data['coordinates'] as Map<String, dynamic>?;
    return ImageRequest(
      id: doc.id,
      title: data['title'] as String? ?? '',
      fileName: data['fileName'] as String? ?? '',
      description: data['description'] as String? ?? '',
      coordinates: coordinates == null ? null : GeoRect.fromMap(coordinates),
      shotAt: (data['shotAt'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    'title': title,
    'fileName': fileName,
    'description': description,
    'coordinates': coordinates?.toMap(),
    'shotAt': shotAt == null ? null : Timestamp.fromDate(shotAt!),
  };
}
