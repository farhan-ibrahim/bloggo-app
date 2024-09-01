import 'package:bloc/bloc.dart';
import 'package:bloggo_app/blocs/posts_cubit.dart';
import 'package:bloggo_app/repositories/post.dart';

enum TableStatus { initial, loading, success, failure }

enum TableEntryLimit {
  l10(10),
  l20(20),
  l50(50),
  lAll(15);

  const TableEntryLimit(this.value);
  final int value;
  String get label => value == 15 ? 'All' : value.toString();
}

class TableCubit extends Cubit<TableState> {
  final repository = PostRepository();
  final int maxLimit = 150;
  final PostsCubit postCubit;

  TableCubit(this.postCubit) : super(TableState.initial());

  void onChangeLimit(TableEntryLimit limit) async {
    emit(TableState.loading());
    try {
      if (limit == TableEntryLimit.lAll) {
        postCubit.getAll();
        emit(TableState.success(limit: limit, page: state.page));
        return;
      }

      emit(TableState.success(limit: limit, page: state.page));
      postCubit.getPosts(limit: limit.value, page: state.page);
    } catch (e) {
      emit(TableState.failure(e.toString()));
    }
  }

  void onChangePage(int page) async {
    emit(TableState.loading());
    postCubit.getPosts(page: page, limit: state.limit.value);
  }
}

class TableState {
  final TableStatus status;
  final TableEntryLimit limit;
  final int page;
  final String keyword;
  final String error;

  TableState({
    required this.status,
    this.limit = TableEntryLimit.l10,
    this.page = 1,
    this.keyword = '',
    this.error = '',
  });

  TableState.initial()
      : this(status: TableStatus.initial, limit: TableEntryLimit.l10);
  TableState.loading() : this(status: TableStatus.loading);
  TableState.success({
    required TableEntryLimit limit,
    required int page,
    String searchKeyword = '',
  }) : this(
          status: TableStatus.success,
          limit: limit,
          keyword: searchKeyword,
        );
  TableState.failure(String error)
      : this(
          status: TableStatus.failure,
          limit: TableEntryLimit.l10,
          error: error,
        );
}
