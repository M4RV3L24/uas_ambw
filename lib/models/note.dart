class Note {
  final String title;
  final String content;
  final DateTime createdAt;
  final String category;

  Note({
    required this.title,
    required this.content,
    required this.createdAt,
    this.category = 'Umum',
  });

  // Convert Note to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'category': category,
    };
  }

  // Create Note from JSON
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      category: json['category'] ?? 'Umum',
    );
  }
}