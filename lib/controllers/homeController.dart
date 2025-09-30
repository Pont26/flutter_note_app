
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notepad_app/Service/NoteService.dart';
import 'package:notepad_app/models/note.dart';
import 'package:notepad_app/screens/create_note.dart';
import 'package:notepad_app/screens/edit_note.dart';

class Homecontroller extends GetxController{

  final NoteService noteService = NoteService();
  final RxList<Note> notes = <Note>[].obs; 


  @override
  void onInit() {
    super.onInit();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    try {
      final fetchedNotes = await noteService.getNotes();
      notes.assignAll(fetchedNotes);
    } catch (e) {
      Get.snackbar("Error", "Error loading notes: $e", 
                   snackPosition: SnackPosition.BOTTOM);
    }
  }

    Future<void> createNote() async {
    final created = await Get.to(() => const CreateNote());
        if (created == true) {
      fetchNotes(); 
    }
  }

  Future<void> editNote(Note note) async {
    final updated = await Get.to(() => EditNote(note: note));
    if (updated == true) {
      fetchNotes(); 
    }
  }

    Future<void> deleteNote(Note note) async {
    // Show confirmation dialog using Get.defaultDialog
    final confirmed = await Get.defaultDialog<bool>(
      title: 'Delete note?',
      content: const Text('This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false), 
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Get.back(result: true), // Dismiss and return true
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    );

    if (confirmed == true) {
      try {
        await noteService.deleteNote(note.id!);
        notes.removeWhere((n) => n.id == note.id); 
        Get.snackbar("Success", "Note deleted", snackPosition: SnackPosition.BOTTOM);
      } catch (e) {
        Get.snackbar("Error", "Failed to delete note: $e", snackPosition: SnackPosition.BOTTOM);
      }
    }
  }
}



