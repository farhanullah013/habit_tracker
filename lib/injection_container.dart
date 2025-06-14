// lib/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import '../data/datasources/habit_local_data_source.dart';
import '../data/models/habit_model.dart';
import '../data/repositories/habit_repository_impl.dart';
import '../domain/repositories/habit_repository.dart';
import '../domain/usecases/add_habit.dart';
import '../domain/usecases/update_habit.dart';
import '../domain/usecases/get_all_habits.dart';
import '../domain/usecases/search_habits.dart';
import '../presentation/blocs/habit/habit_bloc.dart';
import '../presentation/blocs/search/search_bloc.dart';
import '../presentation/viewmodels/habit_view_model.dart';
import '../presentation/viewmodels/search_view_model.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Initialize Hive
  final appDocumentDirectory =
  await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);
  Hive.registerAdapter(HabitModelAdapter());

  // Open Hive boxes
  await Hive.openBox<HabitModel>('habits');

  // Data sources
  sl.registerLazySingleton<HabitLocalDataSource>(
        () => HabitLocalDataSourceImpl(habitBox: Hive.box('habits')),
  );

  // Repository
  sl.registerLazySingleton<HabitRepository>(
        () => HabitRepositoryImpl(localDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => AddHabit(sl()));
  sl.registerLazySingleton(() => UpdateHabit(sl()));
  sl.registerLazySingleton(() => GetAllHabits(sl()));
  sl.registerLazySingleton(() => SearchHabits(sl()));

  // BLoCs
  sl.registerFactory(
        () => HabitBloc(
      addHabit: sl(),
      updateHabit: sl(),
      getAllHabits: sl(),
    ),
  );
  sl.registerFactory(
        () => SearchBloc(searchHabits: sl()),
  );

  // ViewModels
  sl.registerFactory(
        () => HabitViewModel(habitBloc: sl()),
  );
  sl.registerFactory(
        () => SearchViewModel(searchBloc: sl()),
  );
}