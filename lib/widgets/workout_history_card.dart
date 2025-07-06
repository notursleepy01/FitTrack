import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fittrack/models/workout_session_model.dart';

class WorkoutHistoryCard extends StatelessWidget {
  final WorkoutSession workout;

  const WorkoutHistoryCard({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('EEEE, MMM d, yyyy').format(workout.date),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${workout.exercises.length} Exercises • ${workout.totalDuration} min total',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[400]),
            ),
            const Divider(height: 24, thickness: 0.5),
            ...workout.exercises.map((exercise) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      exercise.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      '${exercise.sets}x${exercise.reps} • ${exercise.durationInMinutes} min',
                      style: TextStyle(color: Colors.grey[300]),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}