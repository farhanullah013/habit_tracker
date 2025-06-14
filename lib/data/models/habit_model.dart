import 'package:hive/hive.dart';
import '../../domain/entities/habit_entity.dart';

part 'habit_model.g.dart';

@HiveType(typeId: 0)
class HabitModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final DateTime startDate;

  @HiveField(3)
  final int durationInMinutes;

  @HiveField(4)
  final bool isCompleted;

  @HiveField(5)
  final DateTime? completedDate;

  HabitModel({
    required this.id,
    required this.description,
    required this.startDate,
    required this.durationInMinutes,
    this.isCompleted = false,
    this.completedDate,
  });

  // Remove all getters (hiveId, hiveDescription, etc.)
  // as they're not needed anymore since we're using direct fields

  factory HabitModel.fromEntity(HabitEntity entity) => HabitModel(
    id: entity.id,
    description: entity.description,
    startDate: entity.startDate,
    durationInMinutes: entity.duration.inMinutes,
    isCompleted: entity.isCompleted,
    completedDate: entity.completedDate,
  );

  HabitEntity toEntity() => HabitEntity(
    id: id,
    description: description,
    startDate: startDate,
    duration: Duration(minutes: durationInMinutes),
    isCompleted: isCompleted,
    completedDate: completedDate,
  );
}












// // lib/data/models/habit_model.dart
// import 'package:hive/hive.dart';
// import '../../domain/entities/habit_entity.dart';
//
// part 'habit_model.g.dart';
//
// @HiveType(typeId: 0)
// class HabitModel extends HabitEntity {
//   HabitModel({
//     required String id,
//     required String description,
//     required DateTime startDate,
//     required Duration duration,
//     bool isCompleted = false,
//     DateTime? completedDate,
//   }) : super(
//     id: id,
//     description: description,
//     startDate: startDate,
//     duration: duration,
//     isCompleted: isCompleted,
//     completedDate: completedDate,
//   );
//
//   // Add this factory constructor for Hive
//   factory HabitModel.empty() => HabitModel(
//     id: '',
//     description: '',
//     startDate: DateTime.now(),
//     duration: Duration.zero,
//   );
//
//   // Existing fromEntity factory
//   factory HabitModel.fromEntity(HabitEntity entity) => HabitModel(
//     id: entity.id,
//     description: entity.description,
//     startDate: entity.startDate,
//     duration: entity.duration,
//     isCompleted: entity.isCompleted,
//     completedDate: entity.completedDate,
//   );
//
//   // Hive fields
//   @HiveField(0)
//   String get hiveId => id;
//
//   @HiveField(1)
//   String get hiveDescription => description;
//
//   @HiveField(2)
//   DateTime get hiveStartDate => startDate;
//
//   @HiveField(3)
//   int get hiveDurationInMinutes => duration.inMinutes;
//
//   @HiveField(4)
//   bool get hiveIsCompleted => isCompleted;
//
//   @HiveField(5)
//   DateTime? get hiveCompletedDate => completedDate;
// }