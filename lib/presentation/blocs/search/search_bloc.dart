// lib/presentation/blocs/search/search_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/habit_entity.dart';
import '../../../domain/usecases/search_habits.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchHabits searchHabits;

  SearchBloc({required this.searchHabits}) : super(SearchInitial()) {
    on<SearchHabitsEvent>(_onSearchHabits);
  }

  Future<void> _onSearchHabits(
      SearchHabitsEvent event,
      Emitter<SearchState> emit,
      ) async {
    emit(SearchLoading());
    try {
      final results = await searchHabits(
        description: event.description,
        addedDate: event.addedDate,
        startDate: event.startDate,
        completedDate: event.completedDate,
        duration: event.duration,
      );
      emit(SearchResultsLoaded(results: results));
    } catch (e) {
      emit(SearchError(message: e.toString()));
    }
  }
}