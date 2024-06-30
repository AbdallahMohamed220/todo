import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/blocs/blocs.dart';
import 'package:todo/models/todo_model.dart';

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
        BlocListener<TodoListBloc, TodoListState>(
          listener: (context, state) {
            context.read<ActiveTodoCountBloc>().add(
                  CalculateActiveTodoCountEvent(
                    activeTodoCount: state.todos
                        .where(
                          (Todo todo) => !todo.completed,
                        )
                        .length,
                  ),
                );
          },
          child: Text(
            '${context.watch<ActiveTodoCountBloc>().state.activeTodoCount} Item Left',
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
