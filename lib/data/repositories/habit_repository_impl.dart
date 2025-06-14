// lib/data/repositories/habit_repository_impl.dart
import '../../domain/entities/habit_entity.dart';
import '../../domain/repositories/habit_repository.dart';
import '../datasources/habit_local_data_source.dart';

class HabitRepositoryImpl implements HabitRepository {
  final HabitLocalDataSource localDataSource;

  HabitRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addHabit(HabitEntity habit) async {
    return await localDataSource.addHabit(habit);
  }

  @override
  Future<void> updateHabit(HabitEntity habit) async {
    return await localDataSource.updateHabit(habit);
  }

  @override
  Future<List<HabitEntity>> getAllHabits() async {
    return await localDataSource.getAllHabits();
  }

  @override
  Future<List<HabitEntity>> searchHabits({
    String? description,
    DateTime? addedDate,
    DateTime? startDate,
    DateTime? completedDate,
    Duration? duration,
  }) async {
    return await localDataSource.searchHabits(
      description: description,
      addedDate: addedDate,
      startDate: startDate,
      completedDate: completedDate,
      duration: duration,
    );
  }
}