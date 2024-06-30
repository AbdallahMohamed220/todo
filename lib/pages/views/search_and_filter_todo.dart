import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/utils/debounce.dart';
import 'package:todo/blocs/blocs.dart';

class SearchAndFilterTodo extends StatelessWidget {
  SearchAndFilterTodo({super.key});

  final Debounce debounce = Debounce();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: 'Search todo...',
            border: InputBorder.none,
            filled: true,
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (String? searchTerm) {
            if (searchTerm != null) {
              debounce.run(() {
                context
                    .read<TodoSearchBloc>()
                    .add(SetSearchTermEvent(searchTerm: searchTerm));
              });
            }
          },
        ),
        const SizedBox(height: 20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FilterButton(filter: Filter.all),
            FilterButton(filter: Filter.active),
            FilterButton(filter: Filter.completed),
          ],
        )
      ],
    );
  }
}

class FilterButton extends StatelessWidget {
  const FilterButton({required this.filter, super.key});
  final Filter filter;

  @override
  Widget build(BuildContext context) {
    final currentFilter = context.watch<TodoFilterBloc>().state.filter;
    return TextButton(
      onPressed: () {
        context.read<TodoFilterBloc>().add(ChangeFilterEvent(filter: filter));
      },
      child: Text(
        filter == Filter.all
            ? 'All'
            : filter == Filter.active
                ? 'Active'
                : 'Complete',
        style: TextStyle(
          fontSize: 18,
          color: currentFilter == filter ? Colors.blue : Colors.grey,
        ),
      ),
    );
  }
}
