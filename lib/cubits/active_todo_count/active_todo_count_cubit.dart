import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo/cubits/todo_list/todo_list_cubit.dart';
import 'package:todo/models/todo_model.dart';

part 'active_todo_count_state.dart';

class ActiveTodoCountCubit extends Cubit<ActiveTodoCountState> {
  late final StreamSubscription todoStreamSubscription;
  final TodoListCubit todoListCubit;
  final int initialActiveTodoCount;
  ActiveTodoCountCubit({
    required this.initialActiveTodoCount,
    required this.todoListCubit,
  }) : super(ActiveTodoCountState(activeTodoCount: initialActiveTodoCount)) {
    todoStreamSubscription =
        todoListCubit.stream.listen((TodoListState todoListState) {
      final currentActiveTodoCount = todoListCubit.state.todos
          .where((Todo todo) => !todo.completed)
          .toList()
          .length;

      emit(state.copyWith(activeTodoCount: currentActiveTodoCount));
    });
  }

  @override
  Future<void> close() {
    todoStreamSubscription.cancel();
    return super.close();
  }
}
