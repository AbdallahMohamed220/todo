part of 'todo_filter_cubit.dart';

class TodoFilterState extends Equatable {
  final Filter filter;

  const TodoFilterState({required this.filter});

  factory TodoFilterState.initial() {
    return const TodoFilterState(filter: Filter.all);
  }

  @override
  List<Object?> get props => [filter];

  @override
  bool get stringify => true;

  TodoFilterState copyWith({
    Filter? filter,
  }) {
    return TodoFilterState(
      filter: filter ?? this.filter,
    );
  }
}
