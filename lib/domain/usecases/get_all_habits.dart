// lib/domain/usecases/get_all_habits.dart
import '../entities/habit_entity.dart';
import '../repositories/habit_repository.dart';

class GetAllHabits {
  final HabitRepository repository;

  GetAllHabits(this.repository);

  Future<List<HabitEntity>> call() async {
    return await repository.getAllHabits();
  }
}