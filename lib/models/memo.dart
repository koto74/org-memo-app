// lib/models/memo.dart

class Memo {
  int? id;
  String title;
  String content;

  Memo({this.id, required this.title, required this.content});

  // データベースから取得したMapをMemoオブジェクトに変換する
  factory Memo.fromMap(Map<String, dynamic> map) {
    return Memo(
      id: map['id'],
      title: map['title'],
      content: map['content'],
    );
  }

  // Memoオブジェクトをデータベースに保存するためのMapに変換する
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }
}
