import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notepad_app/models/note.dart';

class NoteService {
final String baseUrl = "http://10.250.1.102:8008/v1/Notes"; 

  Future<Note?> createNote(Note note) async {
    final response = await http.post(Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(note.toOData()));
    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Note.fromOData(data);
    } else {
      throw Exception("Failed to create note: ${response.body}");
    }
  }
Future<List<Note>> getNotes() async {
  final response = await http.get(Uri.parse(baseUrl));
  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);

    // unwrap OData "value" array
    final List<dynamic> data = body['value'];
    final notesList = data.map((json) => Note.fromOData(json)).toList();
    return notesList;
  } else {
    throw Exception("Failed to load notes");
  }
}


Future<Note?> updateNote(Note note) async {
  if (note.id == null) throw Exception("Note ID is required for update");

  final url = "$baseUrl(${note.id})"; 
  final response = await http.patch(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(note.toOData()),
  );
  if (response.statusCode == 200 || response.statusCode == 204) {
    return note;
  } else {
    throw Exception(
        "Failed to update note: ${response.statusCode}, ${response.body}");
  }
}

 Future<void> deleteNote(String id) async {
  if (id.isEmpty) throw Exception("Note ID is required for deletion");

  final url = "$baseUrl($id)"; 
  final response = await http.delete(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
  );
  if (response.statusCode == 200 || response.statusCode == 204) {
    return; // Successfully deleted
  } else if (response.statusCode == 404) {
    throw Exception("Note not found at the server: $url");
  } else {
    throw Exception(
        "Failed to delete note: ${response.statusCode}, ${response.body}");
  }
}

}