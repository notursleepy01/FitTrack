import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fittrack/models/exercise_model.dart';

class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({super.key});

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _durationController = TextEditingController();

  void _saveExercise() {
    if (_formKey.currentState!.validate()) {
      final newExercise = Exercise(
        name: _nameController.text,
        sets: int.parse(_setsController.text),
        reps: int.parse(_repsController.text),
        durationInMinutes: int.parse(_durationController.text),
      );
      Navigator.of(context).pop(newExercise);
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[400]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.1),
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
      validator: (value) => value!.isEmpty ? 'Please enter a value' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Exercise'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Exercise Name',
                icon: Icons.fitness_center,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _setsController,
                label: 'Sets',
                icon: Icons.repeat,
                isNumber: true,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _repsController,
                label: 'Reps',
                icon: Icons.replay_circle_filled,
                isNumber: true,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _durationController,
                label: 'Duration (minutes)',
                icon: Icons.timer,
                isNumber: true,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _saveExercise,
                icon: const Icon(Icons.add),
                label: const Text('Add to Workout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}