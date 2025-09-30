import 'dart:core';


class Note {
  final String? id; // Guid is usually represented as a String in Dart
  final String title;
  final String story; 
  final DateTime? createdAt; 
  final DateTime? updatedAt; 

  Note({
    this.id,
    required this.title,
    required this.story,
     this.createdAt,
     this.updatedAt,
  });

    
 factory Note.fromOData(Map<String, dynamic> json) {
  // Use 'as String?' for safe access
  final String? createdAtString = json['CreatedAt'] as String?;
  final String? updatedAtString = json['UpdatedAt'] as String?;

  return Note(
    id: json['Id'] as String?,
    title: json['Title'] as String,
    story: json['Story'] as String,
    
    // SAFE PARSING: Only call parse if the string is not null.
    createdAt: createdAtString != null ? DateTime.parse(createdAtString) : null,
    updatedAt: updatedAtString != null ? DateTime.parse(updatedAtString) : null,
  );
}


    Map<String, dynamic> toOData() {
    return {
      'Title': title,
      'Story': story,
    };
  }


}