import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo/blocs/todo_list/todo_list_bloc.dart';
import 'package:todo/models/todo_model.dart';

part 'active_todo_count_event.dart';
part 'active_todo_count_state.dart';

class ActiveTodoCountBloc
    extends Bloc<ActiveTodoCountEvent, ActiveTodoCountState> {
  late final StreamSubscription todoStreamSubscription;
  final TodoListBloc todoListBloc;
  final int initialActiveTodoCount;
  ActiveTodoCountBloc({
    required this.initialActiveTodoCount,
    required this.todoListBloc,
  }) : super(ActiveTodoCountState(activeTodoCount: initialActiveTodoCount)) {
    todoStreamSubscription =
        todoListBloc.stream.listen((TodoListState todoListState) {
      final currentActiveTodoCount = todoListBloc.state.todos
          .where((Todo todo) => !todo.completed)
          .toList()
          .length;
      add(CalculateActiveTodoCountEvent(
          activeTodoCount: currentActiveTodoCount));
    });

    on<CalculateActiveTodoCountEvent>((event, emit) {
      emit(state.copyWith(activeTodoCount: event.activeTodoCount));
    });
  }

  @override
  Future<void> close() {
    todoStreamSubscription.cancel();
    return super.close();
  }
}
