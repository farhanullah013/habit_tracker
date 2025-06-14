// lib/domain/usecases/update_habit.dart
import '../entities/habit_entity.dart';
import '../repositories/habit_repository.dart';

class UpdateHabit {
  final HabitRepository repository;

  UpdateHabit(this.repository);

  Future<void> call(HabitEntity habit) async {
    return await repository.updateHabit(habit);
  }
}