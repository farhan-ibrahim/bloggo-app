import 'package:bloc/bloc.dart';
import 'package:bloggo_app/models/post.dart';
import 'package:bloggo_app/repositories/post.dart';

enum PostsStatus { initial, loading, success, failure }

class PostsCubit extends Cubit<PostsState> {
  final repository = PostRepository();

  PostsCubit() : super(PostsState.initial());

  void getAll() async {
    emit(PostsState.loading());
    try {
      final posts = await repository.fetchPosts();
      emit(PostsState.success(posts));
    } catch (e) {
      emit(PostsState.failure(e.toString()));
    }
  }

  void getPosts({
    int? page,
    int? limit,
  }) async {
    emit(PostsState.loading());
    try {
      final posts = await repository.fetchPosts(
        page: page,
        limit: limit,
      );
      emit(PostsState.success(posts));
    } catch (e) {
      emit(PostsState.failure(e.toString()));
    }
  }
}

class PostsState {
  final PostsStatus status;
  final List<Post> posts;
  final String error;

  PostsState({
    required this.status,
    this.posts = const [],
    this.error = '',
  });

  PostsState.initial()
      : this(
          status: PostsStatus.initial,
        );
  PostsState.loading() : this(status: PostsStatus.loading);
  PostsState.success(List<Post> posts)
      : this(status: PostsStatus.success, posts: posts);
  PostsState.failure(String error)
      : this(status: PostsStatus.failure, posts: [], error: error);
}
