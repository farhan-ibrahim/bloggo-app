import 'package:bloggo_app/blocs/posts_cubit.dart';
import 'package:bloggo_app/models/post.dart';
import 'package:bloggo_app/ui/components/comment.dart';
import 'package:bloggo_app/ui/shared/text.dart';
import 'package:bloggo_app/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostArgument {
  final int postId;
  final bool isEditing;
  const PostArgument({required this.postId, this.isEditing = false});
}

class PostScreen extends StatefulWidget {
  final PostArgument? args;
  const PostScreen({
    super.key,
    required this.args,
  });

  @override
  State<PostScreen> createState() => __PostScreenState();
}

class __PostScreenState extends State<PostScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.args?.postId != null) {
      context.read<PostsCubit>().getPost(widget.args?.postId ?? 0);
      context.read<PostsCubit>().getComments(widget.args?.postId ?? 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = context.select((PostsCubit cubit) => cubit.state.post);

    TextEditingController titleController =
        TextEditingController(text: post?.title);
    TextEditingController bodyController =
        TextEditingController(text: post?.body);

    return Scaffold(
      appBar: AppBar(title: Txt.title(post?.title ?? '')),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          border: Border.all(
            color: ThemeColor.primary,
            width: 2,
          ),
        ),
        child: BlocBuilder<PostsCubit, PostsState>(builder: (ctx, state) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.args!.isEditing) ...[
                  Column(
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: bodyController,
                        decoration: const InputDecoration(
                          labelText: 'Write your story',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<PostsCubit>()
                                  .updatePost(
                                    Post(
                                      userId: post?.userId ?? 0,
                                      id: post?.id ?? 0,
                                      title: titleController.text,
                                      body: bodyController.text,
                                    ),
                                  )
                                  .then((_) => Navigator.of(context).pop());
                            },
                            child: const Text('Update'),
                          ),
                        ],
                      )
                    ],
                  ),
                ] else ...[
                  Text(post?.body ?? ''),
                ],
                const Text(
                  "Comments",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Comment(),
              ],
            ),
          );
        }),
      ),
    );
  }
}
