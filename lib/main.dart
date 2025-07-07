import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:fittrack/models/exercise_model.dart';
import 'package:fittrack/models/workout_session_model.dart';
import 'package:fittrack/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Awesome Notifications
  AwesomeNotifications().initialize(
    'resource://drawable/res_app_icon', // Use the default icon
    [
      NotificationChannel(
        channelKey: 'daily_workout_reminder_channel',
        channelName: 'Workout Reminders',
        channelDescription: 'Reminds you to work out every day.',
        defaultColor: Colors.tealAccent,
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      )
    ],
    debug: false, // Set to true to see logs
  );

  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  Hive.registerAdapter(WorkoutSessionAdapter());
  Hive.registerAdapter(ExerciseAdapter());

  await Hive.openBox<WorkoutSession>('workout_box');
  await Hive.openBox('settings_box');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // ... rest of MyApp is unchanged ...
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final darkTheme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color(0xFF121212),
      primaryColor: const Color(0xFF1F1F1F),
      colorScheme: const ColorScheme.dark(
        primary: Colors.tealAccent,
        secondary: Colors.tealAccent,
        surface: Color(0xFF1E1E1E), // Used for card backgrounds
        onPrimary: Colors.black,   // Text on primary color
        onSecondary: Colors.black, // Text on secondary color
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1F1F1F),
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.tealAccent,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.tealAccent,
        foregroundColor: Colors.black,
      ),
    );

    return MaterialApp(
      title: 'FitTrack',
      theme: darkTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
