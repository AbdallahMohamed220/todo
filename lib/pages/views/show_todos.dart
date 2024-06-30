import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/blocs/blocs.dart';
import 'package:todo/blocs/filtered_todos/filtered_todos_bloc.dart';
import 'package:todo/models/todo_model.dart';

class ShowTodos extends StatelessWidget {
  const ShowTodos({super.key});

  List<Todo> setFilteredTodos(
    List<Todo> todos,
    Filter filter,
    String searchTerm,
  ) {
    List<Todo> filteredTodos;

    switch (filter) {
      case Filter.active:
        filteredTodos = todos.where((e) => !e.completed).toList();
        break;
      case Filter.completed:
        filteredTodos = todos.where((e) => e.completed).toList();
        break;
      case Filter.all:
      default:
        filteredTodos = todos;
        break;
    }

    if (searchTerm.isNotEmpty) {
      filteredTodos = todos
          .where((e) => e.desc.toLowerCase().contains(searchTerm))
          .toList();
    }

    return filteredTodos;
  }

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<FilteredTodosBloc>().state.filteredTodos;
    return MultiBlocListener(
      listeners: [
        BlocListener<TodoListBloc, TodoListState>(
          listener: (context, state) {
            final filteredTodos = setFilteredTodos(
              state.todos,
              context.read<TodoFilterBloc>().state.filter,
              context.read<TodoSearchBloc>().state.searchTerm,
            );
            context
                .read<FilteredTodosBloc>()
                .add(CalculateFilteredTodosEvent(filteredTodos: filteredTodos));
          },
        ),
        BlocListener<TodoFilterBloc, TodoFilterState>(
          listener: (context, state) {
            final filteredTodos = setFilteredTodos(
              context.read<TodoListBloc>().state.todos,
              state.filter,
              context.read<TodoSearchBloc>().state.searchTerm,
            );
            context
                .read<FilteredTodosBloc>()
                .add(CalculateFilteredTodosEvent(filteredTodos: filteredTodos));
          },
        ),
        BlocListener<TodoSearchBloc, TodoSearchState>(
          listener: (context, state) {
            final filteredTodos = setFilteredTodos(
              context.read<TodoListBloc>().state.todos,
              context.read<TodoFilterBloc>().state.filter,
              state.searchTerm,
            );
            context
                .read<FilteredTodosBloc>()
                .add(CalculateFilteredTodosEvent(filteredTodos: filteredTodos));
          },
        ),
      ],
      child: ListView.separated(
        primary: false,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: ValueKey(todos[index].id),
            background: const DismissBackground(direction: 0),
            secondaryBackground: const DismissBackground(direction: 1),
            onDismissed: (_) {
              context
                  .read<TodoListBloc>()
                  .add(RemoveTodoEvent(todo: todos[index]));
            },
            confirmDismiss: (_) {
              return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Are you sure'),
                    content: const Text('you want to delete this todo ?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('No'),
                      )
                    ],
                  );
                },
              );
            },
            child: TodoItem(
              todo: todos[index],
            ),
          );
        },
        separatorBuilder: (context, _) => const Divider(
          color: Colors.grey,
        ),
        itemCount: todos.length,
      ),
    );
  }
}

class TodoItem extends StatefulWidget {
  final Todo todo;
  const TodoItem({
    super.key,
    required this.todo,
  });

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  late final TextEditingController textController;
  @override
  void initState() {
    super.initState();

    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        bool error = false;

        textController.text = widget.todo.desc;

        showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, StateSetter setState) {
                return AlertDialog(
                  title: const Text('Edit Todo'),
                  content: TextField(
                    controller: textController,
                    autofocus: true,
                    decoration: InputDecoration(
                      errorText:
                          error == true ? 'Value can not be empty' : null,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'CANCEL',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(
                          () {
                            error = textController.text.trim().isEmpty
                                ? true
                                : false;
                            if (!error) {
                              context.read<TodoListBloc>().add(
                                    EditTodoEvent(
                                      id: widget.todo.id,
                                      todoDesc: textController.text,
                                    ),
                                  );
                              Navigator.pop(context);
                            }
                          },
                        );
                      },
                      child: const Text(
                        'EDIT',
                      ),
                    )
                  ],
                );
              },
            );
          },
        );
      },
      leading: Checkbox(
        value: widget.todo.completed,
        onChanged: (bool? checked) {
          context.read<TodoListBloc>().add(ToggleTodoEvent(id: widget.todo.id));
        },
      ),
      title: Text(
        widget.todo.desc,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class DismissBackground extends StatelessWidget {
  const DismissBackground({required this.direction, super.key});
  final int direction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.red,
      ),
      alignment: direction == 0 ? Alignment.centerLeft : Alignment.centerRight,
      child: const Icon(
        Icons.delete,
        size: 28,
        color: Colors.white,
      ),
    );
  }
}
