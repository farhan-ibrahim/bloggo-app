import 'dart:convert';

import 'package:bloggo_app/models/post.dart';
import 'package:http/http.dart' as http;

class PostRepository {
  final address = "https://jsonplaceholder.typicode.com";

  Future<PostResponse> fetchPosts({
    int? page,
    int? limit,
  }) async {
    final params =
        (page != null && limit != null) ? "?_page=$page&_limit=$limit" : "";
    final url = Uri.parse("$address/posts$params");
    print("Fetching posts from $url");

    final response = await http.get(url);
    print("Response status: ${response.statusCode}");
    if (response.statusCode == 200) {
      // Accessing the headers
      final headers = response.headers;
      final totalCount = headers['x-total-count']; // total count of elements

      List<dynamic> body = jsonDecode(response.body);
      final posts = body.map((dynamic item) => Post.fromJson(item)).toList();

      // Get comments and user for each post
      for (var post in posts) {
        final userResponse = await http.get(
          Uri.parse("$address/users/${post.userId}"),
        );
        if (userResponse.statusCode == 200) {
          post.addUser(jsonDecode(userResponse.body));
        }

        final commentsResponse = await http.get(
          Uri.parse("$address/posts/${post.id}/comments"),
        );
        if (commentsResponse.statusCode == 200) {
          List<dynamic> commentsBody = jsonDecode(commentsResponse.body);
          post.addComments(commentsBody);
        }
      }

      return PostResponse(
          data: posts, totalCount: int.parse(totalCount ?? '0'));
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Post> fetchPostById(int id) async {
    final response = await http.get(Uri.parse('$address/posts/$id'));

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<void> createPost(Post post) async {
    // Create post in API
    final response = await http.post(
      Uri.parse('$address/posts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(post.toJson()),
    );
  }

  Future<void> updatePost(Post post) async {
    // Update post in API
  }

  Future<void> deletePost(int id) async {
    // Delete post in API
  }
}

class PostResponse {
  final List<Post> data;
  final int totalCount;

  PostResponse({
    required this.data,
    required this.totalCount,
  });
}
