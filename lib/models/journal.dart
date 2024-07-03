import 'package:uuid/uuid.dart';

class Journal {
  String id;
  String content;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;

  Journal({
    required this.id,
    required this.content,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  Journal.empty({required int id})
      : id = const Uuid().v1(),
        content = "",
        userId = id,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  Journal.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        content = map['content'] ?? '',
        userId = map['userId'],
        createdAt = DateTime.parse(map['createdAt']),
        updatedAt = DateTime.parse(map['createdAt']);

  Map<String, dynamic> toMap() => {
        'id': id,
        'content': content,
        'userId': userId,
        'createdAt': createdAt.toString(),
        'updatedAt': updatedAt.toString()
      };

  @override
  String toString() {
    return 'userId: $userId \ncontent: $content \ncreated_at: $createdAt\nupdated_at:$updatedAt';
  }
}
