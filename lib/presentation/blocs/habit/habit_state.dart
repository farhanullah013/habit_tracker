// lib/presentation/blocs/habit/habit_state.dart
part of 'habit_bloc.dart';

abstract class HabitState extends Equatable {
  const HabitState();

  @override
  List<Object> get props => [];
}

class HabitInitial extends HabitState {}

class HabitLoading extends HabitState {}

class HabitsLoaded extends HabitState {
  final List<HabitEntity> habits;

  const HabitsLoaded({required this.habits});

  @override
  List<Object> get props => [habits];
}

class HabitError extends HabitState {
  final String message;

  const HabitError({required this.message});

  @override
  List<Object> get props => [message];
}