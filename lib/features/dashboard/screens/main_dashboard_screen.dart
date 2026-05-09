import 'package:flutter/material.dart';
import '../../home/screens/home_screen.dart';
import '../../analysis/screens/analysis_screen.dart';
import '../../symptoms/screens/symptoms_screen.dart';
import '../../auth/screens/welcome_screen.dart';
import '../../../data/services/api_service.dart';
import '../../patient/screens/archive_screen.dart';

class MainDashboardScreen extends StatefulWidget {
  final int initialIndex;
  const MainDashboardScreen({super.key, this.initialIndex = 0});
  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}
class _MainDashboardScreenState extends State<MainDashboardScreen> {
  late int currentIndex;
  final List<Widget> pages = const [
    HomeScreen(),
    SymptomsPage(),
    AnalysisScreen(),
    ArchiveScreen(),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

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
        selectedItemColor: Colors.blue.shade900,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "الأرشيف",
          ),
        ],
      ),
    );
  }
}