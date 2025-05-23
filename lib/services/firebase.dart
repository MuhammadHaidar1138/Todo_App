import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Menyambungkan project kita dengan firestore
  final CollectionReference todos = FirebaseFirestore.instance.collection(
    "todos",
  );

  // Create Data Todo
  Future<void> addTodos(String title, String description) {
    return todos.add({
      "title": title,
      "description": description,
      "timestamp": DateTime.now(),
    });
  }

  // Get all data Todo
  Stream<QuerySnapshot> getTodos() {
    final streamTodos =
        todos.orderBy("timestamp", descending: true).snapshots();
    return streamTodos;
  }

  // Update Data Todo by id
  Future<void> updateTodos(
    String id,
    String title,
    String description,
  ) {
    return todos.doc(id).update({
      "title": title,
      "description": description,
      "timestamp": DateTime.now(),
    });
  }

  // Delete Data Todo by id
  Future<void> deleteTodos(String id) {
    return todos.doc(id).delete();
  }
}
