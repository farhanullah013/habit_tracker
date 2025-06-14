// lib/domain/usecases/search_habits.dart
import '../entities/habit_entity.dart';
import '../repositories/habit_repository.dart';

class SearchHabits {
  final HabitRepository repository;

  SearchHabits(this.repository);

  Future<List<HabitEntity>> call({
    String? description,
    DateTime? addedDate,
    DateTime? startDate,
    DateTime? completedDate,
    Duration? duration,
  }) async {
    return await repository.searchHabits(
      description: description,
      addedDate: addedDate,
      startDate: startDate,
      completedDate: completedDate,
      duration: duration,
    );
  }
}