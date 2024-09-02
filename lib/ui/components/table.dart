import 'package:bloggo_app/blocs/auth_cubit.dart';
import 'package:bloggo_app/blocs/posts_cubit.dart';
import 'package:bloggo_app/ui/components/delete.dart';
import 'package:bloggo_app/ui/components/login.dart';
import 'package:bloggo_app/ui/screens/post.dart';
import 'package:bloggo_app/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/table_cubit.dart';

class ListTable extends StatefulWidget {
  const ListTable({super.key});

  @override
  State<ListTable> createState() => _ListTableState();
}

class _ListTableState extends State<ListTable> {
  void showLoginDialog(ctx) {
    showDialog(
      context: ctx,
      builder: (ctx) => BlocProvider<AuthCubit>.value(
        value: context.read<AuthCubit>(),
        child: const Login(),
      ),
    );
  }

  void showDeleteConfirmationDialog(ctx, post) {
    showDialog(
      context: ctx,
      builder: (ctx) => BlocProvider<PostsCubit>.value(
        value: context.read<PostsCubit>(),
        child: Delete(postId: post.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tableState = context.watch<TableCubit>().state;
    final authState = context.watch<AuthCubit>().state;

    return Expanded(
      child: SingleChildScrollView(
        child: BlocBuilder<PostsCubit, PostsState>(
          builder: (ctx, state) {
            switch (state.status) {
              case PostsStatus.initial:
                context
                    .read<PostsCubit>()
                    .getPosts(limit: tableState.limit.value, page: 1);
                return const Center(child: CircularProgressIndicator());
              case PostsStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case PostsStatus.success:
                return DataTable(
                    columnSpacing: 30,
                    headingRowColor: WidgetStateColor.resolveWith(
                        (states) => ThemeColor.primary),
                    headingTextStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    columns: const [
                      DataColumn(label: Text('TITLE')),
                      DataColumn(label: Text('SUMMARY')),
                      DataColumn(label: Text('AUTHOR')),
                      DataColumn(label: Text('EMAIL')),
                      DataColumn(label: Text('COMMENTS')),
                      DataColumn(label: Center(child: Text('ACTIONS'))),
                    ],
                    rows: [
                      for (final post in state.posts)
                        DataRow(cells: [
                          DataCell(Text(post.title)),
                          DataCell(
                            ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 200,
                                ),
                                child: Text(post.summary)),
                          ),
                          DataCell(Text(post.user!.name)),
                          DataCell(Text(post.user!.email)),
                          DataCell(
                            Center(
                              child: Text(post.commentsCount.toString()),
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed("/post",
                                          arguments: PostArgument(
                                            postId: post.id,
                                            isEditing: false,
                                          ));
                                    },
                                    icon: const Icon(Icons.read_more)),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  color: authState.auth
                                      ? ThemeColor.black
                                      : ThemeColor.disabled,
                                  onPressed: () {
                                    if (!authState.auth) {
                                      showLoginDialog(context);
                                    } else {
                                      Navigator.of(context).pushNamed("/post",
                                          arguments: PostArgument(
                                            postId: post.id,
                                            isEditing: true,
                                          ));
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: authState.auth
                                      ? ThemeColor.black
                                      : ThemeColor.disabled,
                                  onPressed: () {
                                    if (!authState.auth) {
                                      showLoginDialog(context);
                                    } else {
                                      showDeleteConfirmationDialog(
                                          context, post);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ]),
                    ]);
              case PostsStatus.failure:
                return Center(
                  child: Column(
                    children: [
                      Text(state.error),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<PostsCubit>()
                              .getPosts(limit: tableState.limit.value, page: 1);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
