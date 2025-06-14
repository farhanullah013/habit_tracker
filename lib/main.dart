// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/presentation/blocs/habit/habit_bloc.dart';
import 'package:habit_tracker/presentation/blocs/search/search_bloc.dart';
import 'package:habit_tracker/presentation/viewmodels/habit_view_model.dart';
import 'package:habit_tracker/presentation/viewmodels/search_view_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'injection_container.dart' as di;

import 'presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<HabitBloc>()),
        BlocProvider(create: (_) => di.sl<SearchBloc>()),
        ChangeNotifierProvider(create: (_) => di.sl<HabitViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<SearchViewModel>()),
      ],
      child: MaterialApp(
        title: 'Habit Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomePage(),
      ),
    );
  }
}