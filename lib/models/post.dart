import 'package:bloggo_app/models/comment.dart';
import 'package:bloggo_app/models/user.dart';

class Post {
  final int id;
  final String title;
  final String body;
  final int userId;
  User? user;
  List<Comment>? comments;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
    this.user,
    this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'title': title,
        'body': body,
      };

  addUser(Map<String, dynamic> json) {
    user = User.fromJson(json);
  }

  addComments(List<dynamic> json) {
    comments = json.map((dynamic item) => Comment.fromJson(item)).toList();
  }

  String get summary =>
      body.length > 30 ? "${body.substring(0, 30)}..." : "$body...";
  int get commentsCount => comments?.length ?? 0;
}
