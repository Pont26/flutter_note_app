import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notepad_app/controllers/homeController.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Inject the Controller
    final Homecontroller controller = Get.put(Homecontroller());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Note"),
      ),
      body: Obx(
        () {
          if (controller.notes.isEmpty) {
            return const Center(child: Text("No notes yet"));
          }

          // Use the reactive list property
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: controller.notes.length,
            itemBuilder: (context, index) {
              final note = controller.notes[index];
              final formattedDate =
                  DateFormat.yMMMd().add_jm().format(note.createdAt!);

              return Card(
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
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                // 4. Call Controller Methods
                onTap: () => controller.editNote(note),
                onLongPress: () {
                  // Call controller method for deletion
                  controller.deleteNote(note);
                },
              ));
            },
          );
        },
      ),
      // 5. Call Controller Method for FAB
      floatingActionButton: FloatingActionButton(
        onPressed: controller.createNote,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}
