import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubits/active_todo_count/active_todo_count_cubit.dart';
import 'package:todo/cubits/filtered_todos/filtered_todos_cubit.dart';
import 'package:todo/cubits/todo_filter/todo_filter_cubit.dart';
import 'package:todo/cubits/todo_list/todo_list_cubit.dart';
import 'package:todo/cubits/todo_search/todo_search_cubit.dart';
import 'package:todo/pages/todos_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodoFilterCubit>(
          create: (BuildContext context) => TodoFilterCubit(),
        ),
        BlocProvider<TodoSearchCubit>(
          create: (BuildContext context) => TodoSearchCubit(),
        ),
        BlocProvider<TodoListCubit>(
          create: (BuildContext context) => TodoListCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => ActiveTodoCountCubit(
            initialActiveTodoCount:
                context.read<TodoListCubit>().state.todos.length,
          ),
        ),
        BlocProvider(
          create: (BuildContext context) => FilteredTodosCubit(
            initialTodosList: context.read<TodoListCubit>().state.todos,
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
