import 'package:bloggo_app/blocs/auth_cubit.dart';
import 'package:bloggo_app/blocs/posts_cubit.dart';
import 'package:bloggo_app/ui/screens/Home.dart';
import 'package:bloggo_app/ui/screens/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/table_cubit.dart';

void main() async {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloggo.io',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/home', // Set the initial route
      routes: {
        '/home': (context) => MultiBlocProvider(providers: [
              BlocProvider(create: (context) => PostsCubit()),
              BlocProvider(
                create: (context) => TableCubit(context.read<PostsCubit>()),
              ),
              BlocProvider(create: (context) => AuthCubit()),
            ], child: const HomeScreen()),
        '/post': (context) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => PostsCubit()),
                BlocProvider(create: (context) => AuthCubit()),
              ],
              child: PostScreen(
                args:
                    ModalRoute.of(context)!.settings.arguments as PostArgument,
              ),
            ),
      },
    );
  }
}
