// lib/presentation/blocs/habit/habit_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/habit_entity.dart';
import '../../../domain/usecases/add_habit.dart';
import '../../../domain/usecases/update_habit.dart';
import '../../../domain/usecases/get_all_habits.dart';
part 'habit_event.dart';
part 'habit_state.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  final AddHabit addHabit;
  final UpdateHabit updateHabit;
  final GetAllHabits getAllHabits;

  HabitBloc({
    required this.addHabit,
    required this.updateHabit,
    required this.getAllHabits,
  }) : super(HabitInitial()) {
    on<AddHabitEvent>(_onAddHabit);
    on<UpdateHabitEvent>(_onUpdateHabit);
    on<LoadHabitsEvent>(_onLoadHabits);
  }

  Future<void> _onAddHabit(
      AddHabitEvent event,
      Emitter<HabitState> emit,
      ) async {
    emit(HabitLoading());
    try {
      await addHabit(event.habit);
      final habits = await getAllHabits();
      emit(HabitsLoaded(habits: habits));
    } catch (e) {
      emit(HabitError(message: e.toString()));
    }
  }

  Future<void> _onUpdateHabit(
      UpdateHabitEvent event,
      Emitter<HabitState> emit,
      ) async {
    emit(HabitLoading());
    try {
      await updateHabit(event.habit);
      final habits = await getAllHabits();
      emit(HabitsLoaded(habits: habits));
    } catch (e) {
      emit(HabitError(message: e.toString()));
    }
  }

  Future<void> _onLoadHabits(
      LoadHabitsEvent event,
      Emitter<HabitState> emit,
      ) async {
    emit(HabitLoading());
    try {
      final habits = await getAllHabits();
      emit(HabitsLoaded(habits: habits));
    } catch (e) {
      emit(HabitError(message: e.toString()));
    }
  }
}