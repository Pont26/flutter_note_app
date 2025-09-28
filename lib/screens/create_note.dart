import 'package:flutter/material.dart';
import 'package:notepad_app/Service/NoteService.dart';
import 'package:notepad_app/models/note.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final NoteService noteService = NoteService();

  bool isTyping = false;
  @override
  void initState() {
    super.initState();
    titleController.addListener(_onTextChanged);
    bodyController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      isTyping = titleController.text.trim().isNotEmpty ||
          bodyController.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (!isTyping) return; // safety check

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
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop(true); // go back to HomeScreen and reload
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to save note")),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving note: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              controller: titleController,
              style: const TextStyle(fontSize: 28),
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "Title"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: bodyController,
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "Your story"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isTyping ? _saveNote : null,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: isTyping? Colors.black : Colors.grey,
        child: const Icon(Icons.check),
      ),
    );
  }
}
