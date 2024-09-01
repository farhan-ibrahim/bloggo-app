import 'package:bloggo_app/blocs/table_cubit.dart';
import 'package:bloggo_app/ui/shared/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Toolbar extends StatefulWidget {
  const Toolbar({super.key});

  @override
  State<Toolbar> createState() => _ToolbarState();
}

class _ToolbarState extends State<Toolbar> {
  @override
  Widget build(BuildContext context) {
    final tableState = context.watch<TableCubit>().state;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border:
            Border.symmetric(horizontal: BorderSide(color: Colors.grey[500]!)),
      ),
      height: 50,
      child: Row(
        children: [
          Row(
            children: [
              const Text("Show"),
              const SizedBox(width: 10),
              DropdownButton<TableEntryLimit>(
                value: tableState.limit,
                items: [
                  ...TableEntryLimit.values.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e.label),
                    );
                  }),
                ],
                onChanged: (value) {
                  context.read<TableCubit>().onChangeLimit(value!);
                },
              ),
              const SizedBox(width: 10),
              const Text("entries"),
            ],
          ),
          const Spacer(flex: 3),
          const Text("Search"),
          const SizedBox(width: 10),
          const Input(),
        ],
      ),
    );
  }
}
