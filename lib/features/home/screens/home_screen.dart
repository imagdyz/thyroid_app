import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "جاري التحميل...";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name');
    if (name != null && name.isNotEmpty) {
      setState(() {
        userName = "د/ $name";
      });
    } else {
      setState(() {
        userName = "الطبيب";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDoctorCard(),
              const SizedBox(height: 30),
              _buildSectionTitle("💡 نصائح للوقاية والحماية:"),
              const SizedBox(height: 15),
              _buildInfoSection(
                items: [
                  "تناول غذاء متوازن يحتوي على اليود الطبيعي.",
                  "الابتعاد عن الضغوط النفسية والتوتر المزمن.",
                  "إجراء فحص دوري لهرمونات الغدة (TSH) سنوياً.",
                  "ممارسة الرياضة بانتظام لتنشيط الحرق.",
                  "النوم الكافي لتحسين كفاءة الجهاز المناعي.",
                ],
                icon: Icons.check_circle_outline,
                iconColor: Colors.teal,
              ),
              const SizedBox(height: 30),
              _buildSectionTitle("⚠️ محذورات طبية هامة:"),
              const SizedBox(height: 15),
              _buildInfoSection(
                items: [
                  "تجنب تناول أدوية الغدة بدون استشارة دقيقة.",
                  "إهمال أعراض الخمول أو النشاط الزائد.",
                  "إيقاف الجرعات فجأة دون الرجوع للطبيب المختص.",
                  "تناول المكملات العشبية مجهولة المصدر.",
                  "تجاهل تضخم الرقبة أو صعوبة البلع.",
                ],
                icon: Icons.error_outline,
                iconColor: Colors.redAccent,
                isWarning: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A56BE), Color(0xFF5C8DF6)],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: const CircleAvatar(
                  radius: 32,
                  backgroundColor: Color(0xFFD1E3FF),
                  child: Icon(Icons.person, color: Color(0xFF1A56BE), size: 40),
                ),
              ),
              const SizedBox(width: 15),
              // بيانات الدكتور
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "د / بسمه زكريا",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      "استشاري أمراض الغدد الصماء والسكري",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // const Padding(
          //   padding: EdgeInsets.symmetric(vertical: 12),
          //   child: Divider(color: Colors.white30, thickness: 0.8),
          // ),
          // const Row(
          //   children: [
          //     Icon(Icons.star, color: Colors.amber, size: 18),
          //     SizedBox(width: 8),
          //     // Text(
          //     //   "خبرة +15 عاماً في اضطرابات الغدة الدرقية",
          //     //   style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
          //     // ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2D3142),
      ),
    );
  }

  Widget _buildInfoSection({
    required List<String> items,
    required IconData icon,
    required Color iconColor,
    bool isWarning = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 8),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, index) =>
            Divider(color: Colors.grey[50], height: 1),
        itemBuilder: (context, index) {
          return ListTile(
            visualDensity: VisualDensity.compact,
            leading: Icon(icon, color: iconColor, size: 24),
            title: Text(
              items[index],
              style: TextStyle(
                fontSize: 15,
                color: isWarning ? Colors.red[800] : Colors.black,
                height: 1.3,
              ),
            ),
          );
        },
      ),
    );
  }
}

extension ColorExtension on Color {
  static const Color whiteCC = Color(0xCCFFFFFF);
  static const Color blackDE = Color(0xDE000000);
}
