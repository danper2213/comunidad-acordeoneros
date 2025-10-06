import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const _uuid = Uuid();

  /// Crea un nuevo documento en una colección
  static Future<String?> createDocument({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    try {
      final docId = _uuid.v4();
      await _firestore.collection(collection).doc(docId).set({
        ...data,
        'id': docId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return docId;
    } catch (e) {
      print('Error creating document: $e');
      return null;
    }
  }

  /// Obtiene un documento por ID
  static Future<DocumentSnapshot?> getDocument({
    required String collection,
    required String id,
  }) async {
    try {
      return await _firestore.collection(collection).doc(id).get();
    } catch (e) {
      print('Error getting document: $e');
      return null;
    }
  }

  /// Obtiene todos los documentos de una colección
  static Future<QuerySnapshot?> getCollection({
    required String collection,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) async {
    try {
      Query query = _firestore.collection(collection);

      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      return await query.get();
    } catch (e) {
      print('Error getting collection: $e');
      return null;
    }
  }

  /// Actualiza un documento
  static Future<bool> updateDocument({
    required String collection,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collection).doc(id).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error updating document: $e');
      return false;
    }
  }

  /// Elimina un documento
  static Future<bool> deleteDocument({
    required String collection,
    required String id,
  }) async {
    try {
      await _firestore.collection(collection).doc(id).delete();
      return true;
    } catch (e) {
      print('Error deleting document: $e');
      return false;
    }
  }

  /// Obtiene documentos con filtros
  static Future<QuerySnapshot?> getDocumentsWithFilters({
    required String collection,
    required List<FirestoreFilter> filters,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) async {
    try {
      Query query = _firestore.collection(collection);

      for (final filter in filters) {
        query = query.where(filter.field, isEqualTo: filter.value);
      }

      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      return await query.get();
    } catch (e) {
      print('Error getting documents with filters: $e');
      return null;
    }
  }

  /// Escucha cambios en tiempo real de una colección
  static Stream<QuerySnapshot> listenToCollection({
    required String collection,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) {
    Query query = _firestore.collection(collection);

    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots();
  }

  /// Escucha cambios en tiempo real de un documento
  static Stream<DocumentSnapshot> listenToDocument({
    required String collection,
    required String id,
  }) {
    return _firestore.collection(collection).doc(id).snapshots();
  }
}

class FirestoreFilter {
  final String field;
  final dynamic value;

  FirestoreFilter({required this.field, required this.value});
}
