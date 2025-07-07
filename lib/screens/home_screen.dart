import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import 'package:fittrack/models/workout_session_model.dart';
import 'package:fittrack/screens/history_screen.dart';
import 'package:fittrack/screens/settings_screen.dart';
import 'package:fittrack/screens/workout_logging_screen.dart';
import 'package:fittrack/widgets/dashboard_stat_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitTrack Dashboard'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            tooltip: 'Settings',
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<WorkoutSession>('workout_box').listenable(),
        builder: (context, Box<WorkoutSession> box, _) {
          final workouts = box.values.toList()
            ..sort((a, b) => b.date.compareTo(a.date));
          final lastWorkout = workouts.isNotEmpty ? DateFormat.yMMMd().format(workouts.first.date) : 'None';
          final totalWorkouts = workouts.length.toString();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Here is your activity summary.',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.grey[400]),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: DashboardStatCard(
                        icon: Icons.fitness_center,
                        label: 'Total Workouts',
                        value: totalWorkouts,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DashboardStatCard(
                        icon: Icons.event_available,
                        label: 'Last Workout',
                        value: lastWorkout,
                        color: Colors.tealAccent,
                        isDate: true,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Start New Workout'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WorkoutLoggingScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.grey[700]!),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.history),
                    label: const Text('View Workout History'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HistoryScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
