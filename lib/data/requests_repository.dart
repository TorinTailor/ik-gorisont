import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/entities/archive_request.dart';
import '../domain/entities/image_request.dart';

class RequestsRepository {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  Future<void> addImageRequest(ImageRequest request) =>
      _db.collection('image_requests').add({
        ...request.toMap(),
        'userId': _uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

  Future<void> addArchiveRequest(ArchiveRequest request) =>
      _db.collection('archive_requests').add({
        ...request.toMap(),
        'userId': _uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

  // Сортируем на клиенте, чтобы не требовалось составного индекса Firestore.
  // Запись с createdAt == null ещё сохраняется на сервере, считаем её новейшей.
  static int _newestFirst(DateTime? a, DateTime? b) {
    if (a == null && b == null) return 0;
    if (a == null) return -1;
    if (b == null) return 1;
    return b.compareTo(a);
  }

  Stream<List<ImageRequest>> watchImageRequests() => _db
      .collection('image_requests')
      .where('userId', isEqualTo: _uid)
      .snapshots()
      .map((snapshot) {
        final list = snapshot.docs.map(ImageRequest.fromFirestore).toList();
        list.sort((a, b) => _newestFirst(a.createdAt, b.createdAt));
        return list;
      });

  Stream<List<ArchiveRequest>> watchArchiveRequests() => _db
      .collection('archive_requests')
      .where('userId', isEqualTo: _uid)
      .snapshots()
      .map((snapshot) {
        final list = snapshot.docs.map(ArchiveRequest.fromFirestore).toList();
        list.sort((a, b) => _newestFirst(a.createdAt, b.createdAt));
        return list;
      });
}
