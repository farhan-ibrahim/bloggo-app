import 'package:bloc/bloc.dart';
import 'package:bloggo_app/blocs/posts_cubit.dart';
import 'package:bloggo_app/repositories/post.dart';

enum TableStatus { initial, loading, success, failure }

enum TableEntryLimit {
  l10(10),
  l20(20),
  l50(50),
  lAll(1000); // 1000 is a placeholder for all

  const TableEntryLimit(this.value);
  final int value;
  String get label => value > 50 ? 'All' : value.toString();
}

class TableCubit extends Cubit<TableState> {
  final repository = PostRepository();
  final int maxLimit = 150;
  final PostsCubit postCubit;

  TableCubit(this.postCubit) : super(TableState.initial());

  void onChangeLimit(TableEntryLimit limit) async {
    emit(TableState.loading(
      limit: limit,
      page: state.page,
    ));
    try {
      if (limit == TableEntryLimit.lAll) {
        postCubit.getAll();
        emit(TableState.success(limit: limit, page: 1, hasReachedMax: true));
        return;
      }

      final hasReachedMax = await postCubit.getPosts(
        limit: limit.value,
        page: state.page,
      );

      emit(TableState.success(
        limit: limit,
        page: state.page,
        hasReachedMax: hasReachedMax,
      ));
    } catch (e) {
      emit(TableState.failure(e.toString()));
    }
  }

  void onChangePage(int pageToGo) async {
    emit(TableState.loading(
      limit: state.limit,
      page: pageToGo,
    ));
    try {
      final hasReachedMax =
          await postCubit.getPosts(page: pageToGo, limit: state.limit.value);

      emit(TableState.success(
        limit: state.limit,
        page: pageToGo,
        hasReachedMax: hasReachedMax,
      ));
    } catch (e) {
      emit(TableState.failure(e.toString()));
    }
  }

  void hasReachedMax(int totalCount) {
    if (state.page * state.limit.value >= totalCount) {
      emit(TableState(
        status: TableStatus.loading,
        limit: state.limit,
        page: state.page,
        hasReachedMax: true,
      ));
    }
    emit(TableState.loading(limit: state.limit, page: state.page));
  }
}

class TableState {
  final TableStatus status;
  final TableEntryLimit limit;
  final int page;
  final String keyword;
  final bool hasReachedMax;
  final String error;

  TableState({
    required this.status,
    this.limit = TableEntryLimit.l10,
    this.page = 1,
    this.keyword = '',
    this.error = '',
    this.hasReachedMax = false,
  });

  TableState.initial()
      : this(
          status: TableStatus.initial,
          limit: TableEntryLimit.l10,
        );
  TableState.loading({
    required TableEntryLimit limit,
    required int page,
  }) : this(
          status: TableStatus.loading,
          limit: limit,
          page: page,
        );
  TableState.success({
    required TableEntryLimit limit,
    required int page,
    bool hasReachedMax = false,
  }) : this(
          status: TableStatus.success,
          limit: limit,
          page: page,
          hasReachedMax: hasReachedMax,
        );
  TableState.failure(String error)
      : this(
          status: TableStatus.failure,
          limit: TableEntryLimit.l10,
          error: error,
        );
}
