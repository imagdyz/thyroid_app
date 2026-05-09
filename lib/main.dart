import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auth/screens/welcome_screen.dart';
import 'features/dashboard/screens/main_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getInt('user_id') != null;

  runApp(ThyroidCareApp(isLoggedIn: isLoggedIn));
}

class ThyroidCareApp extends StatelessWidget {
  final bool isLoggedIn;

  const ThyroidCareApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? const MainDashboardScreen() : const WelcomeScreen(),
    );
  }
}
