part of 'todo_filter_bloc.dart';

sealed class TodoFilterEvent extends Equatable {
  const TodoFilterEvent();

  @override
  List<Object> get props => [];
}

class ChangeFilterEvent extends TodoFilterEvent {
  final Filter filter;

  const ChangeFilterEvent({required this.filter});

  @override
  List<Object> get props => [filter];

  @override
  String toString() => 'ChangeFilterEvent(filter: $filter)';
}
