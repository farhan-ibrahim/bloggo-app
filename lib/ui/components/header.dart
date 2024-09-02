import 'package:bloggo_app/blocs/auth_cubit.dart';
import 'package:bloggo_app/ui/components/login.dart';
import 'package:bloggo_app/ui/components/profile.dart';
import 'package:bloggo_app/ui/screens/post.dart';
import 'package:bloggo_app/ui/shared/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  void showLoginDialog(ctx) {
    showDialog(
      context: ctx,
      builder: (ctx) => BlocProvider<AuthCubit>.value(
        value: context.read<AuthCubit>(),
        child: const Login(),
      ),
    );
  }

  void showProfileDialog(ctx, user) {
    showDialog(
      context: ctx,
      builder: (ctx) => BlocProvider<AuthCubit>.value(
        value: context.read<AuthCubit>(),
        child: Profile(user: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;

    return Row(
      children: [
        Txt.title('Bloggo'),
        const Spacer(),
        if (authState.auth) ...[
          Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/post',
                      arguments: const PostArgument(
                        postId: 0,
                        isEditing: true,
                      ));
                },
                child: const Text('Create New Post'),
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      showProfileDialog(context, authState.user);
                    },
                    icon: const Icon(Icons.person),
                  ),
                  Txt(authState.user?.name ?? "User"),
                ],
              ),
            ],
          ),
        ] else ...[
          IconButton(
            onPressed: () {
              showLoginDialog(context);
            },
            icon: const Icon(Icons.login),
          ),
        ]
      ],
    );
  }
}
