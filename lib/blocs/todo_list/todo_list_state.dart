part of 'todo_list_bloc.dart';

class TodoListState extends Equatable {
  final List<Todo> todos;

  const TodoListState(this.todos);

  factory TodoListState.initial() {
    return TodoListState(
      [
        Todo(id: '1', desc: 'Clean the room'),
        Todo(id: '2', desc: 'Wash the dish'),
        Todo(id: '3', desc: 'Do Home Work'),
      ],
    );
  }

  @override
  List<Object?> get props => [todos];

  TodoListState copyWith({
    List<Todo>? todos,
  }) {
    return TodoListState(
      todos ?? this.todos,
    );
  }
}
