import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  
  // Menyambungkan project kita dengan firestore
  final CollectionReference todos = 
      FirebaseFirestore.instance.collection("todos");

  // Create Data Todo
  Future<void> addTodos(String title, String description) {
    return todos.add({
      "title": title, 
      "description": description, 
      "timestamp": DateTime.now()
    });
  }
}