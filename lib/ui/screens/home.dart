import 'package:bloggo_app/blocs/posts_cubit.dart';
import 'package:bloggo_app/blocs/table_cubit.dart';
import 'package:bloggo_app/ui/components/toolbar.dart';
import 'package:bloggo_app/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/footer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => __HomeScreenState();
}

class __HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tableState = context.watch<TableCubit>().state;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Home',
          textAlign: TextAlign.left,
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          border: Border.all(
            color: ThemeColor.primary,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            const Toolbar(),
            Expanded(
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
                                      child:
                                          Text(post.commentsCount.toString()),
                                    ),
                                  ),
                                  DataCell(Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            print("READ MORE");
                                          },
                                          icon: const Icon(Icons.read_more)),
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          print("EDIT");
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          print("DELETE");
                                        },
                                      ),
                                    ],
                                  )),
                                ]),
                            ]);
                      case PostsStatus.failure:
                        return Center(
                          child: Text(state.error),
                        );
                    }
                  },
                ),
              ),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
