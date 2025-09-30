import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notepad_app/controllers/addNoteController.dart';

class CreateNote extends StatelessWidget {
  const CreateNote({super.key});

  @override
  Widget build(BuildContext context) {
    final AddNoteController controller = Get.put(AddNoteController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("New Note"),
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
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: controller.bodyController,
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "Your story"),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          onPressed: controller.isTyping.value ? controller.saveNote : null,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          foregroundColor:
              controller.isTyping.value ? Colors.black : Colors.grey,
          child: const Icon(Icons.check),
        ),
      ),
    );
  }
}
