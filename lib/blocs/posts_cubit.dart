import 'package:bloc/bloc.dart';
import 'package:bloggo_app/blocs/table_cubit.dart';
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

  void reset() {
    emit(PostsState.initial());
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
          posts: [],
          error: '',
        );
  PostsState.loading() : this(status: PostsStatus.loading);
  PostsState.success(List<Post> posts)
      : this(status: PostsStatus.success, posts: posts, error: '');
  PostsState.failure(String error)
      : this(status: PostsStatus.failure, posts: [], error: error);
}
