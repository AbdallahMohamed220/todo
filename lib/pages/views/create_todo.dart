import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/blocs/blocs.dart';

class CreateTodo extends StatefulWidget {
  const CreateTodo({super.key});

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  final TextEditingController newTodoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: newTodoController,
      decoration: const InputDecoration(
        hintText: 'What to do ?',
      ),
      onSubmitted: (String? todoDesc) {
        if (todoDesc != null && todoDesc.trim().isNotEmpty) {
          context.read<TodoListBloc>().add(AddTodoEvent(todoDesc: todoDesc));
          newTodoController.clear();
        }
      },
    );
  }
}
