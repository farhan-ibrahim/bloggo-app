import 'dart:convert';

import 'package:bloggo_app/blocs/table_cubit.dart';
import 'package:bloggo_app/models/post.dart';
import 'package:http/http.dart' as http;

class PostRepository {
  Future<List<Post>> fetchPosts({
    int? page = 1,
    int? limit,
  }) async {
    // Fetch posts from API
    final response = await http.get(
      Uri.parse(
          "https://jsonplaceholder.typicode.com/posts?_page=$page&_limit=${limit ?? TableEntryLimit.l10.value}"),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Post.fromJson(item)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<Post> fetchPostById(int id) async {
    // Fetch post by ID from API
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Post.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<void> createPost(Post post) async {
    // Create post in API
  }

  Future<void> updatePost(Post post) async {
    // Update post in API
  }

  Future<void> deletePost(int id) async {
    // Delete post in API
  }
}
