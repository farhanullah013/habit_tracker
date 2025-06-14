// lib/presentation/viewmodels/habit_view_model.dart

import 'package:flutter/material.dart';
import '../../domain/entities/habit_entity.dart';
import '../blocs/habit/habit_bloc.dart';

class HabitViewModel with ChangeNotifier {
  final HabitBloc _habitBloc;
  List<HabitEntity> _habits = [];
  bool _isLoading = false;
  String? _error;

  HabitViewModel({required HabitBloc habitBloc}) : _habitBloc = habitBloc {
    _habitBloc.stream.listen((state) {
      if (state is HabitsLoaded) {
        _habits = state.habits;
        _isLoading = false;
        _error = null;
      } else if (state is HabitLoading) {
        _isLoading = true;
      } else if (state is HabitError) {
        _error = state.message;
        _isLoading = false;
      }
      notifyListeners();
    });

    loadHabits();
  }

  List<HabitEntity> get habits => _habits;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Map<DateTime, List<HabitEntity>> get groupedHabits {
    final grouped = <DateTime, List<HabitEntity>>{};
    for (final habit in _habits) {
      final date = DateTime(habit.startDate.year, habit.startDate.month, habit.startDate.day);
      grouped.putIfAbsent(date, () => []).add(habit);
    }
    return grouped;
  }

  void loadHabits() => _habitBloc.add(LoadHabitsEvent());
  Future<void> addHabit(HabitEntity habit) async {
    _habitBloc.add(AddHabitEvent(habit));
    // Wait for the operation to complete
    await _habitBloc.stream.firstWhere(
          (state) => state is HabitsLoaded || state is HabitError,
    );
  }
  void updateHabit(HabitEntity habit) => _habitBloc.add(UpdateHabitEvent(habit));
}