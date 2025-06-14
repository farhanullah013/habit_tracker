// lib/data/datasources/habit_local_data_source.dart
import 'package:hive/hive.dart';
import '../../domain/entities/habit_entity.dart';
import '../models/habit_model.dart';

abstract class HabitLocalDataSource {
  Future<void> addHabit(HabitEntity habit);
  Future<void> updateHabit(HabitEntity habit);
  Future<List<HabitEntity>> getAllHabits();
  Future<List<HabitEntity>> searchHabits({
    String? description,
    DateTime? addedDate,
    DateTime? startDate,
    DateTime? completedDate,
    Duration? duration,
  });
}

class HabitLocalDataSourceImpl implements HabitLocalDataSource {
  final Box<HabitModel> habitBox;

  HabitLocalDataSourceImpl({required this.habitBox});

  @override
  Future<void> addHabit(HabitEntity habit) async {
    await habitBox.put(habit.id, HabitModel.fromEntity(habit));
  }

  @override
  Future<void> updateHabit(HabitEntity habit) async {
    await habitBox.put(habit.id, HabitModel.fromEntity(habit));
  }

  @override
  Future<List<HabitEntity>> getAllHabits() async {
    return habitBox.values.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<HabitEntity>> searchHabits({
    String? description,
    DateTime? addedDate,
    DateTime? startDate,
    DateTime? completedDate,
    Duration? duration,
  }) async {
    final allHabits = habitBox.values;
    final filtered = allHabits.where((habit) {
      bool matches = true;

      // Description filter
      if (description != null && description.isNotEmpty) {
        matches = matches &&
            habit.description.toLowerCase().contains(description.toLowerCase());
      }

      // Added date filter (compares with habit creation date)
      if (addedDate != null) {
        matches = matches && _isSameDay(habit.startDate, addedDate);
      }

      // Start date filter
      if (startDate != null) {
        matches = matches && _isSameDay(habit.startDate, startDate);
      }

      // Completed date filter
      if (completedDate != null) {
        matches = matches &&
            habit.isCompleted &&
            habit.completedDate != null &&
            _isSameDay(habit.completedDate!, completedDate);
      }

      // Duration filter
      if (duration != null) {
        matches = matches && habit.durationInMinutes == duration.inMinutes;
      }

      return matches;
    });

    return filtered.map((model) => model.toEntity()).toList();
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}