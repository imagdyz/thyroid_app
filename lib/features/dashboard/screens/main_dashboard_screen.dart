import 'package:flutter/material.dart';
import '../../home/screens/home_screen.dart';
import '../../analysis/screens/analysis_screen.dart';
import '../../symptoms/screens/symptoms_screen.dart';
import '../../auth/screens/welcome_screen.dart';
import '../../../data/services/api_service.dart';

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});
  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}
class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int currentIndex = 0;
  final List<Widget> pages = const [
    HomeScreen(),
    SymptomsPage(),
    AnalysisScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thyroid App"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'تسجيل الخروج',
            onPressed: () async {
              await ApiService.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue.shade50,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "الرئيسية",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: "الاعراض",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.science),
            label: "التحاليل",
          ),
        ],
      ),
    );
  }
}