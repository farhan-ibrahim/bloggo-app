import 'package:bloggo_app/blocs/posts_cubit.dart';
import 'package:bloggo_app/blocs/table_cubit.dart';
import 'package:bloggo_app/ui/components/toolbar.dart';
import 'package:bloggo_app/ui/shared/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[500]!),
              ),
              height: 50,
              child: const Toolbar(),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: BlocBuilder<PostsCubit, PostsState>(
                  builder: (ctx, state) {
                    print("STATE: ${state.status}");
                    print("STATE: ${state.posts.length}");

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
                            headingRowColor: WidgetStateColor.resolveWith(
                                (states) =>
                                    const Color.fromARGB(255, 241, 240, 245)),
                            columns: [
                              DataColumn(label: Txt.bold('Title')),
                              DataColumn(label: Txt.bold('Body')),
                            ],
                            rows: [
                              for (final post in state.posts)
                                DataRow(cells: [
                                  DataCell(Text(post.title)),
                                  DataCell(Text(post.body)),
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
          ],
        ),
      ),
    );
  }
}
