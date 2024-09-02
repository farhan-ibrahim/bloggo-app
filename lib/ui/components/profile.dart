import 'package:bloggo_app/blocs/auth_cubit.dart';
import 'package:bloggo_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Profile extends StatefulWidget {
  final User user;
  const Profile({super.key, required this.user});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return BlocProvider(
      create: (context) => AuthCubit(),
      child: AlertDialog(
        title: const Text('Profile'),
        content: Column(
          children: [
            Text("Name : ${user.name}"),
            Text("Username : ${user.username}"),
            Text("Email : ${user.email}"),
            Text("Phone : ${user.phone}"),
            Text("Website : ${user.website}"),
            Text("Company : ${user.company}"),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
