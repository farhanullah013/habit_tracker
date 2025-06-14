// lib/presentation/pages/search_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/habit_entity.dart';
import '../viewmodels/search_view_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  DateTime? _addedDate;
  DateTime? _startDate;
  DateTime? _completedDate;
  Duration? _duration;

  final List<Duration> _durationOptions = [
    const Duration(minutes: 15),
    const Duration(minutes: 30),
    const Duration(minutes: 45),
    const Duration(hours: 1),
    const Duration(hours: 1, minutes: 15),
    const Duration(hours: 1, minutes: 30),
    const Duration(hours: 1, minutes: 45),
    const Duration(hours: 2),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final viewModel = Provider.of<SearchViewModel>(context, listen: false);
    viewModel.search(
      description: _searchController.text.isNotEmpty
          ? _searchController.text
          : null,
      addedDate: _addedDate,
      startDate: _startDate,
      completedDate: _completedDate,
      duration: _duration,
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SearchViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Habits'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search by description',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ExpansionTile(
            title: const Text('Advanced Filters'),
            children: [
              ListTile(
                title: Text(
                  _addedDate != null
                      ? 'Added on: ${DateFormat.yMd().format(_addedDate!)}'
                      : 'Filter by added date',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, (date) {
                  setState(() {
                    _addedDate = date;
                  });
                  _onSearchChanged();
                }),
              ),
              ListTile(
                title: Text(
                  _startDate != null
                      ? 'Starts on: ${DateFormat.yMd().format(_startDate!)}'
                      : 'Filter by start date',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, (date) {
                  setState(() {
                    _startDate = date;
                  });
                  _onSearchChanged();
                }),
              ),
              ListTile(
                title: Text(
                  _completedDate != null
                      ? 'Completed on: ${DateFormat.yMd().format(_completedDate!)}'
                      : 'Filter by completed date',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, (date) {
                  setState(() {
                    _completedDate = date;
                  });
                  _onSearchChanged();
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButtonFormField<Duration>(
                  value: _duration,
                  hint: const Text('Filter by duration'),
                  items: [
                    const DropdownMenuItem<Duration>(
                      value: null,
                      child: Text('Any duration'),
                    ),
                    ..._durationOptions.map((duration) {
                      final hours = duration.inHours;
                      final minutes = duration.inMinutes % 60;
                      final label = hours > 0
                          ? '$hours hour${hours > 1 ? 's' : ''} ${minutes > 0 ? '$minutes minute${minutes > 1 ? 's' : ''}' : ''}'
                          : '$minutes minute${minutes > 1 ? 's' : ''}';
                      return DropdownMenuItem(
                        value: duration,
                        child: Text(label),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _duration = value;
                    });
                    _onSearchChanged();
                  },
                  isExpanded: true,
                ),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: _buildResults(viewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(SearchViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.error != null) {
      return Center(child: Text('Error: ${viewModel.error}'));
    }

    if (viewModel.results.isEmpty) {
      return const Center(child: Text('No results found'));
    }

    return ListView.builder(
      itemCount: viewModel.results.length,
      itemBuilder: (context, index) {
        final habit = viewModel.results[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(habit.description),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Duration: ${habit.duration.inMinutes} minutes'),
                Text('Start: ${habit.startDate.toString()}'),
                if (habit.isCompleted && habit.completedDate != null)
                  Text('Completed: ${habit.completedDate.toString()}'),
              ],
            ),
            trailing: Checkbox(
              value: habit.isCompleted,
              onChanged: null,
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(
      BuildContext context,
      Function(DateTime) onDateSelected,
      ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }
}