import 'package:bloggo_app/blocs/posts_cubit.dart';
import 'package:bloggo_app/blocs/table_cubit.dart';
import 'package:bloggo_app/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
    final tableState = context.watch<TableCubit>().state;
    final postState = context.watch<PostsCubit>().state;

    return Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(flex: 3),
          Visibility(
            visible: tableState.page != 1,
            child: IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                if (tableState.status == TableStatus.loading ||
                    postState.status == PostsStatus.loading) return;
                if (tableState.page == 1) return;
                context.read<TableCubit>().onChangePage(tableState.page - 1);
              },
              icon: const Icon(Icons.chevron_left),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(ThemeColor.primary),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 50,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: ThemeColor.primary, width: 2),
              ),
              child: Text(
                tableState.page.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Visibility(
            visible: !tableState.hasReachedMax,
            child: IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                if (tableState.status == TableStatus.loading ||
                    postState.status == PostsStatus.loading) return;
                context.read<TableCubit>().onChangePage(tableState.page + 1);
              },
              icon: const Icon(Icons.chevron_right),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(ThemeColor.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
