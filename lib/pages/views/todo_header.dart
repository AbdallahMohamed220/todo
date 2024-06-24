import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubits/active_todo_count/active_todo_count_cubit.dart';
import 'package:todo/cubits/todo_list/todo_list_cubit.dart';

class TodoHeader extends StatelessWidget {
  const TodoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Todos',
          style: TextStyle(
            fontSize: 40,
          ),
        ),
        BlocListener<TodoListCubit, TodoListState>(
          listener: (context, state) {
            context.read<ActiveTodoCountCubit>().calculateActiveTodoCount(
                state.todos.where((element) => !element.completed).length);
          },
          child: Text(
            '${context.watch<ActiveTodoCountCubit>().state.activeTodoCount} Item Left',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.redAccent,
            ),
          ),
        ),
      ],
    );
  }
}
