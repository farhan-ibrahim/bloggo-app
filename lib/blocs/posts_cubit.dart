import 'package:bloc/bloc.dart';
import 'package:bloggo_app/blocs/table_cubit.dart';
import 'package:bloggo_app/models/comment.dart';
import 'package:bloggo_app/models/post.dart';
import 'package:bloggo_app/repositories/post.dart';

enum PostsStatus { initial, loading, success, failure }

class PostsCubit extends Cubit<PostsState> {
  final repository = PostRepository();

  PostsCubit() : super(PostsState.initial());

  void getAll() async {
    emit(PostsState.loading());
    try {
      final response = await repository.fetchPosts();
      emit(PostsState.success(response.data));
    } catch (e) {
      emit(PostsState.failure(e.toString()));
    }
  }

  Future<bool> getPosts({
    int? page,
    int? limit,
  }) async {
    emit(PostsState.loading());
    late bool result = false;
    try {
      final response = await repository.fetchPosts(
        page: page,
        limit: limit,
      );
      emit(PostsState.success(response.data));
      final totalCount = response.totalCount;
      final currentPage = page ?? 1;
      final currentLimit = limit ?? TableEntryLimit.l10.value;
      final hasReachedMax = currentPage * currentLimit >= totalCount;
      result = hasReachedMax;
    } catch (e) {
      emit(PostsState.failure(e.toString()));
    }
    return result;
  }

  void getPost(int id) async {
    emit(PostsState.loading());
    try {
      final post = await repository.fetchPostById(id);
      emit(PostsState(
          status: PostsStatus.success, post: post, comments: state.comments));
    } catch (e) {
      emit(PostsState(status: PostsStatus.failure, error: e.toString()));
    }
  }

  void getComments(int postId) async {
    emit(PostsState.loading());
    try {
      final comments = await repository.fetchComments(postId);
      emit(PostsState(
          status: PostsStatus.success, comments: comments, post: state.post));
    } catch (e) {
      emit(PostsState(status: PostsStatus.failure, error: e.toString()));
    }
  }

  Future<void> createPost(Post post) async {
    emit(PostsState.loading(state.posts));
    try {
      final newPost = await repository.createPost(post);
      emit(PostsState(
        status: PostsStatus.success,
        posts: state.posts..insert(0, newPost),
        comments: state.comments,
      ));
    } catch (e) {
      emit(PostsState(status: PostsStatus.failure, error: e.toString()));
    }
  }

  Future<void> updatePost(Post post) async {
    emit(PostsState.loading(state.posts));
    try {
      final updatedPost = await repository.updatePost(post);
      emit(PostsState(
        status: PostsStatus.success,
        post: updatedPost,
        comments: state.comments,
        posts: state.posts.map((Post p) {
          if (p.id == updatedPost.id) {
            return updatedPost;
          }
          return p;
        }).toList(),
      ));
    } catch (e) {
      emit(PostsState(status: PostsStatus.failure, error: e.toString()));
    }
  }

  Future<void> deletePost(int postId) async {
    emit(PostsState.loading(state.posts));
    try {
      await repository.deletePost(postId);
      final list = state.posts.where((Post post) => post.id != postId).toList();
      emit(PostsState(
        status: PostsStatus.success,
        posts: list,
        comments: state.comments,
      ));
    } catch (e) {
      emit(PostsState(status: PostsStatus.failure, error: e.toString()));
    }
  }

  void reset() {
    emit(PostsState.initial());
  }
}

class PostsState {
  final PostsStatus status;
  final List<Post> posts;
  final String error;
  final Post? post;
  final List<Comment>? comments;

  PostsState({
    required this.status,
    this.posts = const [],
    this.error = '',
    this.post,
    this.comments = const [],
  });

  PostsState.initial()
      : this(
          status: PostsStatus.initial,
          posts: [],
          error: '',
        );
  PostsState.loading([List<Post>? posts])
      : this(status: PostsStatus.loading, posts: posts ?? []);
  PostsState.success(List<Post> posts)
      : this(status: PostsStatus.success, posts: posts, error: '');
  PostsState.failure(String error)
      : this(status: PostsStatus.failure, posts: [], error: error);
}
