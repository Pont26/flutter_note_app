import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notepad_app/Service/NoteService.dart';
import 'package:notepad_app/models/note.dart';

class AddNoteController extends GetxController {

  late final TextEditingController titleController;
  late final TextEditingController bodyController;
  final isTyping = false.obs;

  final NoteService noteService = NoteService();


  @override
  void onInit() {
    super.onInit();

    titleController = TextEditingController(text: '');
    bodyController = TextEditingController(text: '');

    titleController.addListener(_onTextChanged);
    bodyController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
      isTyping.value = titleController.text.trim().isNotEmpty ||
        bodyController.text.trim().isNotEmpty;
  }

  Future<void> saveNote() async {
    if (!isTyping.value) return; // safety check

    final note = Note(
      id: null,
      title: titleController.text.trim(),
      story: bodyController.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      final Note? createdNote = await noteService.createNote(note);

      if (createdNote != null) {
        Get.back(result: true);// go back to HomeScreen and reload
      } else {
        Get.snackbar(
          "Save Failed",
          "Failed to save note",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Error adding note: $e",
      snackPosition: SnackPosition.BOTTOM,
      );
    }
  }


    @override
  void onClose() {
      titleController.dispose();
      bodyController.dispose();
      super.onClose();
  }


}
