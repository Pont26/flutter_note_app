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
  return Note(
    id: json['Id'],
    title: json['Title'],
    story: json['Story'],
    createdAt: DateTime.parse(json['CreatedAt']),
    updatedAt: DateTime.parse(json['UpdatedAt']), 
  );
}


    Map<String, dynamic> toOData() {
    return {
      'Title': title,
      'Story': story,
    };
  }


}