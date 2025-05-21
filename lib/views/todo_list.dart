import 'package:flutter/material.dart';
import 'package:todo_app/services/firebase.dart';

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

  void openAlertBox() {
    final formKey = GlobalKey<FormState>();

    // Menampilkan dialog
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Data Todo"),
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
                  firestoreService.addTodos(
                    _judulController.text,
                    _deskripsiController.text,
                  );
                  
                  _judulController.clear();
                  _deskripsiController.clear();
                  Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo-List", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
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
