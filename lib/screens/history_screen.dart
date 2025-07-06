import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:fittrack/models/workout_session_model.dart';
import 'package:fittrack/widgets/workout_history_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout History'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<WorkoutSession>('workout_box').listenable(),
        builder: (context, Box<WorkoutSession> box, _) {
          if (box.values.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 100,
                    color: Colors.grey[700],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No History Found',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Complete a workout to see it here.',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }
          final sortedWorkouts = box.values.toList()
            ..sort((a, b) => b.date.compareTo(a.date));

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: sortedWorkouts.length,
            itemBuilder: (context, index) {
              final workout = sortedWorkouts[index];
              return WorkoutHistoryCard(workout: workout);
            },
          );
        },
      ),
    );
  }
}