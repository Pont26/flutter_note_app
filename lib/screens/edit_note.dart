import 'package:flutter/material.dart';
import 'package:notepad_app/Service/NoteService.dart';
import 'package:notepad_app/models/note.dart';

class EditNote extends StatefulWidget {
  final Note note;

  const EditNote({super.key, required this.note});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  late final TextEditingController titleController;
  late final TextEditingController bodyController;
  final NoteService noteService = NoteService();
  bool isTyping = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note.title);
    bodyController = TextEditingController(text: widget.note.story);
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

Future<void> _updateNote() async {
  if (!isTyping) return;

  final updatedNote = Note(
    id: widget.note.id,
    title: titleController.text.trim(),
    story: bodyController.text.trim(),
    createdAt: widget.note.createdAt,
    updatedAt: DateTime.now(),
  );

  try {
    final Note? result = await noteService.updateNote(updatedNote);


    if (result != null) {
     // ignore: use_build_context_synchronously
      Navigator.of(context).pop(true); // reload HomeScreen
    } else {
       //ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Failed to update note")));
    }
  } catch (e) {
    //ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Error updating note: $e")));
  }
}


  @override
  Widget build(BuildContext context) {
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
              controller: titleController,
              style: const TextStyle(fontSize: 28),
              decoration:
                  const InputDecoration(border: InputBorder.none, hintText: "Title"),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TextFormField(
                controller: bodyController,
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
    floatingActionButton: FloatingActionButton(
        onPressed: isTyping ? _updateNote : null,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: isTyping? Colors.black : Colors.grey,
        child: const Icon(Icons.check),
      ),
    );
  }
}
