import 'package:hive/hive.dart';
import 'package:fittrack/models/exercise_model.dart';

part 'workout_session_model.g.dart';

@HiveType(typeId: 0)
class WorkoutSession extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final List<Exercise> exercises;

  WorkoutSession({
    required this.id,
    required this.date,
    required this.exercises,
  });

  // A computed property to get total duration
  int get totalDuration {
    if (exercises.isEmpty) {
      return 0;
    }
    return exercises
        .map((e) => e.durationInMinutes)
        .reduce((value, element) => value + element);
  }
}