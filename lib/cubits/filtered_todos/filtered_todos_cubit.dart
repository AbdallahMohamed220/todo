import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo/cubits/todo_filter/todo_filter_cubit.dart';
import 'package:todo/cubits/todo_list/todo_list_cubit.dart';
import 'package:todo/cubits/todo_search/todo_search_cubit.dart';
import 'package:todo/models/todo_model.dart';

part 'filtered_todos_state.dart';

class FilteredTodosCubit extends Cubit<FilteredTodosState> {
  late final StreamSubscription todoFilterStreamSubscription;
  late final StreamSubscription todoSearchStreamSubscription;
  late final StreamSubscription todoListStreamSubscription;

  final List<Todo> initialTodosList;

  final TodoFilterCubit todoFilterCubit;
  final TodoSearchCubit todoSearchCubit;
  final TodoListCubit todoListCubit;

  FilteredTodosCubit({
    required this.initialTodosList,
    required this.todoFilterCubit,
    required this.todoSearchCubit,
    required this.todoListCubit,
  }) : super(FilteredTodosState(filteredTodos: initialTodosList)) {
    todoFilterStreamSubscription = todoFilterCubit.stream.listen((event) {
      setFilteredTodos();
    });

    todoSearchStreamSubscription = todoSearchCubit.stream.listen((event) {
      setFilteredTodos();
    });

    todoListStreamSubscription = todoListCubit.stream.listen((event) {
      setFilteredTodos();
    });
  }

  void setFilteredTodos() {
    List<Todo> filteredTodos;

    switch (todoFilterCubit.state.filter) {
      case Filter.active:
        filteredTodos =
            todoListCubit.state.todos.where((e) => !e.completed).toList();
        break;
      case Filter.completed:
        filteredTodos =
            todoListCubit.state.todos.where((e) => e.completed).toList();
        break;
      case Filter.all:
      default:
        filteredTodos = todoListCubit.state.todos;
        break;
    }

    if (todoSearchCubit.state.searchTerm.isNotEmpty) {
      filteredTodos = todoListCubit.state.todos
          .where((e) =>
              e.desc.toLowerCase().contains(todoSearchCubit.state.searchTerm))
          .toList();
    }

    emit(state.copyWith(filteredTodos: filteredTodos));
  }

  @override
  Future<void> close() {
    todoFilterStreamSubscription.cancel();
    todoSearchStreamSubscription.cancel();
    todoListStreamSubscription.cancel();
    return super.close();
  }
}
