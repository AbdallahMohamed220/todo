import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo/models/todo_model.dart';

part 'todo_list_state.dart';

class TodoListCubit extends Cubit<TodoListState> {
  TodoListCubit() : super(TodoListState.initial());

  void addTodo(String todoDesc) {
    final newTodo = Todo(desc: todoDesc);
    // ... is called spread operator that use to get all list items
    final newTodos = [...state.todos, newTodo];

    emit(state.copyWith(todos: newTodos));
    print(state);
  }

  void editTodo(String id, String todoDesc) {
    final newTodos = state.todos.map(
      (Todo todo) {
        if (todo.id == id) {
          return Todo(
            id: todo.id,
            desc: todoDesc,
            completed: todo.completed,
          );
        }
        return todo;
      },
    ).toList();

    emit(state.copyWith(todos: newTodos));
  }

  void toggleTodo(
    String id,
  ) {
    final newTodos = state.todos.map(
      (Todo todo) {
        if (todo.id == id) {
          return Todo(
            id: id,
            desc: todo.desc,
            completed: !todo.completed,
          );
        }
        return todo;
      },
    ).toList();

    emit(state.copyWith(todos: newTodos));
  }

  void removeTodo(String id) {
    final newTodos = state.todos.where((e) => e.id != id).toList();
    emit(state.copyWith(todos: newTodos));
  }
}
