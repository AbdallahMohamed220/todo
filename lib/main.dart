import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/blocs/blocs.dart';

import 'pages/todos_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodoFilterBloc>(
          create: (BuildContext context) => TodoFilterBloc(),
        ),
        BlocProvider<TodoSearchBloc>(
          create: (BuildContext context) => TodoSearchBloc(),
        ),
        BlocProvider<TodoListBloc>(
          create: (BuildContext context) => TodoListBloc(),
        ),
        BlocProvider(
          create: (BuildContext context) => ActiveTodoCountBloc(
            initialActiveTodoCount:
                context.read<TodoListBloc>().state.todos.length,
            todoListBloc: BlocProvider.of<TodoListBloc>(context),
          ),
        ),
        BlocProvider(
          create: (BuildContext context) => FilteredTodosBloc(
            initialTodosList: context.read<TodoListBloc>().state.todos,
            todoFilterBloc: BlocProvider.of<TodoFilterBloc>(context),
            todoSearchBloc: BlocProvider.of<TodoSearchBloc>(context),
            todoListBloc: BlocProvider.of<TodoListBloc>(context),
          ),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ),
          useMaterial3: true,
        ),
        home: const TodosPage(),
      ),
    );
  }
}
