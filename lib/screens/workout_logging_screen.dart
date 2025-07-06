import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import 'package:fittrack/models/exercise_model.dart';
import 'package:fittrack/models/workout_session_model.dart';
import 'package:fittrack/screens/add_exercise_screen.dart';
import 'package:fittrack/widgets/exercise_card.dart';

class WorkoutLoggingScreen extends StatefulWidget {
  const WorkoutLoggingScreen({super.key});

  @override
  State<WorkoutLoggingScreen> createState() => _WorkoutLoggingScreenState();
}

class _WorkoutLoggingScreenState extends State<WorkoutLoggingScreen> {
  final List<Exercise> _exercises = [];

  void _addExercise() async {
    final newExercise = await Navigator.push<Exercise>(
      context,
      MaterialPageRoute(builder: (context) => const AddExerciseScreen()),
    );

    if (newExercise != null) {
      setState(() {
        _exercises.add(newExercise);
      });
    }
  }

  void _saveWorkout() async {
    if (_exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one exercise.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final workoutBox = Hive.box<WorkoutSession>('workout_box');
    final newWorkout = WorkoutSession(
      id: const Uuid().v4(),
      date: DateTime.now(),
      exercises: _exercises,
    );

    await workoutBox.add(newWorkout);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Workout Saved! Keep it up!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log New Workout'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            onPressed: _saveWorkout,
            tooltip: 'Save Workout',
          )
        ],
      ),
      body: _exercises.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.note_add_outlined,
                      size: 100,
                      color: Colors.grey[700],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Your workout is empty.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Press the + button to add your first exercise.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: _exercises.length,
              itemBuilder: (context, index) {
                final exercise = _exercises[index];
                return ExerciseCard(
                  exercise: exercise,
                  onDelete: () {
                    setState(() {
                      _exercises.removeAt(index);
                    });
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExercise,
        tooltip: 'Add Exercise',
        child: const Icon(Icons.add),
      ),
    );
  }
}