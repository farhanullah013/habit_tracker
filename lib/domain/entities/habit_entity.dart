class HabitEntity {
  final String id;
  final String description;
  final DateTime startDate;
  final Duration duration;
  final bool isCompleted;
  final DateTime? completedDate;

  HabitEntity({
    required this.id,
    required this.description,
    required this.startDate,
    required this.duration,
    this.isCompleted = false,
    this.completedDate,
  });
}