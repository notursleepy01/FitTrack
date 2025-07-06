import 'package:hive/hive.dart';

part 'exercise_model.g.dart';

@HiveType(typeId: 1)
class Exercise extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int sets;

  @HiveField(2)
  final int reps;
  
  @HiveField(3)
  final int durationInMinutes;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.durationInMinutes,
  });
}