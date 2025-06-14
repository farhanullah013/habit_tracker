// lib/presentation/viewmodels/search_view_model.dart
import 'package:flutter/material.dart';
import '../../domain/entities/habit_entity.dart';
import '../blocs/search/search_bloc.dart';

class SearchViewModel with ChangeNotifier {
  final SearchBloc searchBloc;

  SearchViewModel({required this.searchBloc}) {
    _init();
  }

  List<HabitEntity> _results = [];
  List<HabitEntity> get results => _results;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  void _init() {
    searchBloc.stream.listen((state) {
      if (state is SearchLoading) {
        _isLoading = true;
        _error = null;
      } else if (state is SearchResultsLoaded) {
        _results = state.results;
        _isLoading = false;
        _error = null;
      } else if (state is SearchError) {
        _error = state.message;
        _isLoading = false;
      }
      notifyListeners();
    });
  }

  void search({
    String? description,
    DateTime? addedDate,
    DateTime? startDate,
    DateTime? completedDate,
    Duration? duration,
  }) {
    searchBloc.add(SearchHabitsEvent(
      description: description,
      addedDate: addedDate,
      startDate: startDate,
      completedDate: completedDate,
      duration: duration,
    ));
  }

  @override
  void dispose() {
    searchBloc.close();
    super.dispose();
  }
}