import 'package:flutter/material.dart';

class DetailTodo extends StatefulWidget {
  final String title;
  final String description;

  const DetailTodo({super.key, required this.title, required this.description});

  @override
  State<DetailTodo> createState() => _DetailTodoState();
}

class _DetailTodoState extends State<DetailTodo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Todo", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_outlined, color: Colors.brown),
        ),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Judul",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.brown,
              ),
            ),
            Text(
              widget.title, 
              style: TextStyle(
                fontSize: 16
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Deskripsi",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.brown,
              ),
            ),
            Text(
              widget.description, 
              style: TextStyle(
                fontSize: 16
              ),
            ),
          ],
        ),
      ),
    );
  }
}
