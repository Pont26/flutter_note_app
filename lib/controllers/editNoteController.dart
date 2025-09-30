import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notepad_app/Service/NoteService.dart';
import 'package:notepad_app/models/note.dart';

class EditNoteController extends GetxController {
  final Note originalNote;

  late final TextEditingController titleController;
  late final TextEditingController bodyController;

  final isTyping = false.obs;

  final NoteService noteService = NoteService();

  EditNoteController({required this.originalNote});

  @override
  void onInit() {
    super.onInit();

    titleController = TextEditingController(text: originalNote.title);
    bodyController = TextEditingController(text: originalNote.story);

    titleController.addListener(_onTextChanged);
    bodyController.addListener(_onTextChanged);

    _onTextChanged();
  }

  void _onTextChanged() {

      isTyping.value = titleController.text.trim().isNotEmpty ||
        bodyController.text.trim().isNotEmpty;
  }

  Future<void> updateNote() async {
    if (!isTyping.value) return;

    final updatedNote = Note(
      id: originalNote.id,
      title: titleController.text.trim(),
      story: bodyController.text.trim(),
      createdAt: originalNote.createdAt,
      updatedAt: DateTime.now(),
    );
    try {
      final Note? result = await noteService.updateNote(updatedNote);

      if (result != null) {
        // Use Get.back() to pop the screen and return a result
        Get.back(result: true);
      } else {
        Get.snackbar(
          "Update Failed",
          "Failed to update note",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Error updating note: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    // Dispose the controllers when the GetX controller is closed
    titleController.dispose();
    bodyController.dispose();
    super.onClose();
  }
}
