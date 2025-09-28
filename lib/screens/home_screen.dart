import 'package:flutter/material.dart';
import 'package:notepad_app/Service/NoteService.dart';
import 'package:notepad_app/models/note.dart';
import 'package:notepad_app/screens/create_note.dart';
import 'package:intl/intl.dart';
import 'package:notepad_app/screens/edit_note.dart'; // add this for date formatting

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NoteService noteService = NoteService();
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    try {
      final fetchedNotes = await noteService.getNotes();
      setState(() {
        notes = fetchedNotes;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error loading notes: $e")));
    }
  }

  Future<void> _editNote(Note note) async {
    final updated = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditNote(note: note),
      ),
    );

    if (updated == true) {
      fetchNotes(); // reload after edit
    }
  }

  Future<bool> _confirmDelete(Note note) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete note?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop( _, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(_, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (result == true) {
      try {
        await noteService.deleteNote(note.id!); // call delete API
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Note deleted")));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to delete note: $e")));
        return false;
      }
    }
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Note"),
      ),
      body: notes.isEmpty
          ? const Center(child: Text("No notes yet"))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                final formattedDate =
                    DateFormat.yMMMd().add_jm().format(note.createdAt!);

                return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    margin:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        note.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            note.story,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      onTap: () => _editNote(note),
                      onLongPress: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (ctx) => SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading:
                                    const Icon(Icons.delete, color: Colors.red),
                                title: const Text("Delete Note"),
                                onTap: () async {
                                  Navigator.pop(ctx);
                                  final confirmed = await _confirmDelete(note);
                                  if (confirmed) fetchNotes();
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ));
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CreateNote()),
          );
          if (created == true) {
            fetchNotes(); // reload notes after creating one
          }
        },
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}
