import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/services/firebase.dart';
import 'package:todo_app/views/detail_todo.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  // Mengambil Fungsi dari service
  final FirestoreService firestoreService = FirestoreService();

  // Controller Form Input Data
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  // Form input data
  void openAlertBox({String? todoId, String? title, String? description}) {
    // Isi form input data untuk update
    if (todoId != null) {
      _judulController.text = title ?? '';
      _deskripsiController.text = description ?? '';
    } else {
      _judulController.clear();
      _deskripsiController.clear();
    }

    final formKey = GlobalKey<FormState>();

    // Menampilkan dialog
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title:
                todoId == null
                    ? const Text("Tambah Todo")
                    : const Text("Update Todo"),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _judulController,
                    decoration: const InputDecoration(labelText: "Judul"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Judul tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _deskripsiController,
                    decoration: const InputDecoration(labelText: "Deskripsi"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Deskripsi tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _judulController.clear();
                  _deskripsiController.clear();
                  Navigator.pop(context);
                },
                child: const Text(
                  "Batal",
                  style: TextStyle(color: Colors.brown),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.brown),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // jika tidoId null/tidak ada maka kita akan menambah data
                    if (todoId == null) {
                      firestoreService.addTodos(
                        _judulController.text,
                        _deskripsiController.text,
                      );
                    } else {
                      // jika todoId tidak null/ada maka kita akan mengupdate data
                      firestoreService.updateTodos(
                        todoId,
                        _judulController.text,
                        _deskripsiController.text,
                      );
                    }
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  "Simpan",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  // Pop untuk hapus data
  void openDeleteAlertBox(String? todoId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Hapus Data Todo"),
            content: const Text("Apakah anda yakin ingin menghapus data ini?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Batal",
                  style: TextStyle(color: Colors.brown),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.brown),
                ),
                onPressed: () {
                  firestoreService.deleteTodos(todoId!);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Hapus",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo-List", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getTodos(),
        builder: (context, snapshot) {
          //  Kondisi jika kita memiliki data
          if (snapshot.hasData) {
            List todolist = snapshot.data!.docs;

            return Padding(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: todolist.length,
                itemBuilder: (context, index) {
                  // Fungsi mengambil data per ID
                  DocumentSnapshot document = todolist[index];
                  String todoId = document.id;

                  // Mengambil data dari tiap ID
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String title = data["title"];
                  String description = data["description"];

                  // Menampilkan data
                  return Card(
                    child: ListTile(
                      title: Text(title),
                      subtitle: Text(description),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => DetailTodo(
                                  title: title,
                                  description: description,
                                ),
                          ),
                        );
                      },

                      // Icon button Update dan Hapus
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.brown),
                            onPressed: () {
                              openAlertBox(
                                todoId: todoId,
                                title: title,
                                description: description,
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              openDeleteAlertBox(todoId);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Colors.brown),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openAlertBox();
        },
        backgroundColor: Colors.brown,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
