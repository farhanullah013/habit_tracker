// lib/presentation/blocs/habit/habit_event.dart
part of 'habit_bloc.dart';

abstract class HabitEvent extends Equatable {
  const HabitEvent();

  @override
  List<Object> get props => [];
}

class AddHabitEvent extends HabitEvent {
  final HabitEntity habit;

  const AddHabitEvent(this.habit);

  @override
  List<Object> get props => [habit];
}

class UpdateHabitEvent extends HabitEvent {
  final HabitEntity habit;

  const UpdateHabitEvent(this.habit);

  @override
  List<Object> get props => [habit];
}

class LoadHabitsEvent extends HabitEvent {}