import 'package:bloggo_app/blocs/auth_cubit.dart';
import 'package:bloggo_app/ui/components/login.dart';
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

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;

    return Row(
      children: [
        Txt.title('Bloggo'),
        const Spacer(),
        if (authState.auth) ...[
          Txt(authState.user!.name),
          Row(
            children: [
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      print("PROFILE");
                    },
                    icon: const Icon(Icons.person),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  context.read<AuthCubit>().logout();
                },
                icon: const Icon(Icons.logout),
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
