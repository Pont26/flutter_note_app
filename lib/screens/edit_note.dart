import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:notepad_app/controllers/editNoteController.dart';
import 'package:notepad_app/models/note.dart';

class EditNote extends StatelessWidget {
  final Note note;

  const EditNote({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final EditNoteController controller =
        Get.put(EditNoteController(originalNote: note));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Edit Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextFormField(
              controller: controller.titleController,
              style: const TextStyle(fontSize: 28),
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "Title"),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TextFormField(
                controller: controller.bodyController,
                style: const TextStyle(fontSize: 18),
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: "Your story"),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          onPressed: controller.isTyping.value ? controller.updateNote : null,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          foregroundColor: controller.isTyping.value ? Colors.black : Colors.grey,
          child: const Icon(Icons.check),
        ),
      ),
    );
    
  }
}
