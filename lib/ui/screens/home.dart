import 'package:bloggo_app/blocs/auth_cubit.dart';
import 'package:bloggo_app/blocs/posts_cubit.dart';
import 'package:bloggo_app/ui/components/header.dart';
import 'package:bloggo_app/ui/components/toolbar.dart';
import 'package:bloggo_app/ui/components/table.dart';

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
  bool showError = false;
  String error = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (showError) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: Text(error),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    showError = false;
                    error = "";
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final postState = context.watch<PostsCubit>().state;

    if ((!authState.auth &&
        authState.error != "" &&
        authState.status == AuthStatus.failure)) {
      setState(() {
        showError = true;
        error = authState.error;
      });
      // To set state to default
      context.read<AuthCubit>().logout();
    }

    if (postState.status == PostsStatus.failure && postState.error != "") {
      setState(() {
        showError = true;
        error = postState.error;
      });
      context.read<PostsCubit>().reset();
    }

    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Header()),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          border: Border.all(
            color: ThemeColor.primary,
            width: 2,
          ),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Toolbar(),
            ListTable(),
            Footer(),
          ],
        ),
      ),
    );
  }
}
