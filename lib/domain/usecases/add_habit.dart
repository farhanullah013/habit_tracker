// lib/domain/usecases/add_habit.dart
import '../entities/habit_entity.dart';
import '../repositories/habit_repository.dart';

class AddHabit {
  final HabitRepository repository;

  AddHabit(this.repository);

  Future<void> call(HabitEntity habit) async {
    return await repository.addHabit(habit);
  }
}