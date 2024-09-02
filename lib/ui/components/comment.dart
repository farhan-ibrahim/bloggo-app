import 'package:bloggo_app/blocs/posts_cubit.dart';
import 'package:bloggo_app/ui/shared/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Comment extends StatelessWidget {
  const Comment({super.key});

  @override
  Widget build(BuildContext context) {
    final comments = context.select((PostsCubit cubit) => cubit.state.comments);

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (comments != null && comments.isNotEmpty) ...[
              for (final comment in comments)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(comment.body),
                    Row(
                      children: [
                        Txt.caption(comment.name),
                        const SizedBox(width: 10),
                        Txt.caption(comment.email),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
            ]
          ],
        ),
      ),
    );
  }
}
