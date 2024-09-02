import 'package:bloggo_app/blocs/posts_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Delete extends StatefulWidget {
  final int postId;
  const Delete({super.key, required this.postId});

  @override
  State<Delete> createState() => _DeleteState();
}

class _DeleteState extends State<Delete> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostsCubit(),
      child: AlertDialog(
        title: const Text('Delete'),
        content: const Column(
          children: [Text("Are you sure you want to delete this post?")],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<PostsCubit>().deletePost(widget.postId);
              Navigator.of(context).pop();
            },
            child: const Text('Yes, delete'),
          ),
        ],
      ),
    );
  }
}
