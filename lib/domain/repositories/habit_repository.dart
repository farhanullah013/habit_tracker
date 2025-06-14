// lib/domain/repositories/habit_repository.dart
import '../entities/habit_entity.dart';

abstract class HabitRepository {
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