import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo/blocs/blocs.dart';
import 'package:todo/blocs/todo_filter/todo_filter_bloc.dart';
import 'package:todo/blocs/todo_search/todo_search_bloc.dart';
import 'package:todo/models/todo_model.dart';

part 'filtered_todos_event.dart';
part 'filtered_todos_state.dart';

class FilteredTodosBloc extends Bloc<FilteredTodosEvent, FilteredTodosState> {
  late final StreamSubscription todoFilterStreamSubscription;
  late final StreamSubscription todoSearchStreamSubscription;
  late final StreamSubscription todoListStreamSubscription;

  final List<Todo> initialTodosList;

  final TodoFilterBloc todoFilterBloc;
  final TodoSearchBloc todoSearchBloc;
  final TodoListBloc todoListBloc;

  FilteredTodosBloc({
    required this.initialTodosList,
    required this.todoFilterBloc,
    required this.todoSearchBloc,
    required this.todoListBloc,
  }) : super(FilteredTodosState(filteredTodos: initialTodosList)) {
    todoFilterStreamSubscription = todoFilterBloc.stream.listen((event) {
      setFilteredTodos();
    });

    todoSearchStreamSubscription = todoSearchBloc.stream.listen((event) {
      setFilteredTodos();
    });

    todoListStreamSubscription = todoListBloc.stream.listen((event) {
      setFilteredTodos();
    });
    on<CalculateFilteredTodosEvent>((event, emit) {
      emit(state.copyWith(filteredTodos: event.filteredTodos));
    });
  }

  void setFilteredTodos() {
    List<Todo> filteredTodos;

    switch (todoFilterBloc.state.filter) {
      case Filter.active:
        filteredTodos =
            todoListBloc.state.todos.where((e) => !e.completed).toList();
        break;
      case Filter.completed:
        filteredTodos =
            todoListBloc.state.todos.where((e) => e.completed).toList();
        break;
      case Filter.all:
      default:
        filteredTodos = todoListBloc.state.todos;
        break;
    }

    if (todoSearchBloc.state.searchTerm.isNotEmpty) {
      filteredTodos = todoListBloc.state.todos
          .where((e) =>
              e.desc.toLowerCase().contains(todoSearchBloc.state.searchTerm))
          .toList();
    }

    add(CalculateFilteredTodosEvent(filteredTodos: filteredTodos));
  }

  @override
  Future<void> close() {
    todoFilterStreamSubscription.cancel();
    todoSearchStreamSubscription.cancel();
    todoListStreamSubscription.cancel();
    return super.close();
  }
}
