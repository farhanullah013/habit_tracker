// lib/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../injection_container.dart';
import '../blocs/habit/habit_bloc.dart';
import '../viewmodels/habit_view_model.dart';
import 'add_habit_page.dart';
import 'search_page.dart';
import '../../domain/entities/habit_entity.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HabitBloc>(),
      child: ChangeNotifierProvider(
        create: (context) => HabitViewModel(
          habitBloc: context.read<HabitBloc>(),
        ),
        child: const _HomePageContent(),
      ),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HabitViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchPage()),
              );
            },
          ),
        ],
      ),
      body: _buildBody(viewModel),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (_) => const AddHabitPage()),
      //     );
      //     // Refresh after returning from AddHabitPage
      //     context.read<HabitBloc>().add(LoadHabitsEvent());
      //   },
      //   child: const Icon(Icons.add),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const AddHabitPage()),
          );
          if (added == true) {
            viewModel.loadHabits(); // Explicit refresh
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(HabitViewModel viewModel) {
    if (viewModel.isLoading && viewModel.habits.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.error != null) {
      return Center(child: Text('Error: ${viewModel.error}'));
    }

    if (viewModel.habits.isEmpty) {
      return const Center(child: Text('No habits added yet'));
    }

    return _buildHabitList(viewModel);
  }

  Widget _buildHabitList(HabitViewModel viewModel) {
    final groupedHabits = viewModel.groupedHabits;
    final dates = groupedHabits.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      itemCount: dates.length,
      itemBuilder: (context, index) {
        final date = dates[index];
        final habits = groupedHabits[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${date.day}/${date.month}/${date.year}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            ...habits.map((habit) => _buildHabitItem(context, habit, viewModel)),
          ],
        );
      },
    );
  }

  Widget _buildHabitItem(
      BuildContext context,
      HabitEntity habit,
      HabitViewModel viewModel,
      ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(habit.description),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Duration: ${habit.duration.inMinutes} minutes'),
            Text('Start: ${habit.startDate.toString()}'),
            if (habit.isCompleted && habit.completedDate != null)
              Text('Completed: ${habit.completedDate.toString()}'),
          ],
        ),
        trailing: Checkbox(
          value: habit.isCompleted,
          onChanged: (value) {
            final updatedHabit = HabitEntity(
              id: habit.id,
              description: habit.description,
              startDate: habit.startDate,
              duration: habit.duration,
              isCompleted: value ?? false,
              completedDate: value == true ? DateTime.now() : null,
            );
            viewModel.updateHabit(updatedHabit);
          },
        ),
      ),
    );
  }
}