// lib/presentation/blocs/search/search_event.dart
part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchHabitsEvent extends SearchEvent {
  final String? description;
  final DateTime? addedDate;
  final DateTime? startDate;
  final DateTime? completedDate;
  final Duration? duration;

  const SearchHabitsEvent({
    this.description,
    this.addedDate,
    this.startDate,
    this.completedDate,
    this.duration,
  });

  @override
  List<Object> get props => [
    if (description != null) description!,
    if (addedDate != null) addedDate!,
    if (startDate != null) startDate!,
    if (completedDate != null) completedDate!,
    if (duration != null) duration!,
  ];
}