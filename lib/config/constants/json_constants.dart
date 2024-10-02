class JsonConstants {
  static const String jsonHint = '''
{
    "postId": 1,
    "id": 1,
    "name": "id labore ex et quam laborum",
    "email": "Eliseo@gardner.biz",
    "body": "laudantium enim quasi ..."
}
''';

  static const String dartClassHint = '''
class MyClass {
  final int? postId;
  final int? id;
  final String? name;
  final String? email;
  final String? body;

  MyClass({
    this.postId,
    this.id,
    this.name,
    this.email,
    this.body,
  });

  factory MyClass.fromJson(Map<String, dynamic> json) {
    return MyClass(
      postId: json['postId'],
      id: json['id'],
      name: json['name'],
      email: json['email'],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'id': id,
      'name': name,
      'email': email,
      'body': body,
    };
  }
}
''';
}
