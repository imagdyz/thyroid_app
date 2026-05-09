import 'package:flutter/material.dart';
import '../../../data/services/api_service.dart';
import '../../patient/screens/patient_screen.dart';

class SymptomsPage extends StatefulWidget {
  const SymptomsPage({super.key});
  @override
  State<SymptomsPage> createState() => _SymptomsPageState();
}

class _SymptomsPageState extends State<SymptomsPage> {
  List<Map<String, dynamic>> symptomsData = [];
  List<String> selectedSymptoms = [];
  bool isLoading = false;
  bool isFetching = true;

  @override
  void initState() {
    super.initState();
    _fetchSymptoms();
  }

  Future<void> _fetchSymptoms() async {
    final data = await ApiService.getSymptoms();
    if (mounted) {
      setState(() {
        symptomsData = data.cast<Map<String, dynamic>>();
        isFetching = false;
      });
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'add_chart': return Icons.add_chart;
      case 'battery_alert': return Icons.battery_alert;
      case 'favorite_border': return Icons.favorite_border;
      case 'sentiment_dissatisfied': return Icons.sentiment_dissatisfied;
      case 'psychology_alt': return Icons.psychology_alt;
      case 'dry_cleaning': return Icons.dry_cleaning;
      case 'ac_unit': return Icons.ac_unit;
      case 'airline_seat_legroom_reduced': return Icons.airline_seat_legroom_reduced;
      case 'face': return Icons.face;
      case 'remove_red_eye': return Icons.remove_red_eye;
      case 'record_voice_over': return Icons.record_voice_over;
      case 'pan_tool': return Icons.pan_tool;
      case 'water_drop': return Icons.water_drop;
      case 'directions_walk': return Icons.directions_walk;
      case 'trending_down': return Icons.trending_down;
      case 'monitor_heart': return Icons.monitor_heart;
      case 'back_hand': return Icons.back_hand;
      case 'psychology': return Icons.psychology;
      case 'mood_bad': return Icons.mood_bad;
      case 'bedtime': return Icons.bedtime;
      case 'wc': return Icons.wc;
      case 'thermostat': return Icons.thermostat;
      case 'directions_run': return Icons.directions_run;
      case 'person_pin': return Icons.person_pin;
      case 'content_cut': return Icons.content_cut;
      case 'fitness_center': return Icons.fitness_center;
      default: return Icons.medical_services;
    }
  }

  String _calculateDiagnosis() {
    int hypo = 0;
    int hyper = 0;
    for (var id in selectedSymptoms) {
      var s = symptomsData.firstWhere((e) => e['id'] == id);
      if (s['type'] == 'hypo') {
        hypo++;
      } else if (s['type'] == 'hyper') {
        hyper++;
      } else {
        hypo++;
        hyper++;
      }
    }
    if (selectedSymptoms.length < 2) {
      return "يرجى اختيار عرضين على الأقل للتشخيص.";
    }
    if (hypo > hyper) {
      return "يوجد اشتباه في خمول الغدة الدرقية.";
    } else if (hyper > hypo) {
      return "يوجد اشتباه في فرط نشاط الغدة الدرقية.";
    } else {
      return "الأعراض مختلطة، يرجى إجراء فحص TSH للتأكد.";
    }
  }

  void _handleSave() {
    if (selectedSymptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("برجاء اختيار الأعراض أولاً")),
      );
      return;
    }
    if (selectedSymptoms.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى اختيار عرضين على الأقل")),
      );
      return;
    }

    String result = _calculateDiagnosis();
    List<String> symptomNames = selectedSymptoms.map((id) {
      var s = symptomsData.firstWhere((e) => e['id'] == id);
      return s['title'] as String;
    }).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientScreen(
          diagnosisResult: result,
          selectedSymptoms: selectedSymptoms,
          symptomNames: symptomNames,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("اختر الأعراض التي تشعر بيها"),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: isFetching 
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const SizedBox(height: 15),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: symptomsData.length,
                  itemBuilder: (context, index) {
                    final item = symptomsData[index];
                    final isSelected = selectedSymptoms.contains(item['id']);
                    return GestureDetector(
                      onTap: () => setState(() {
                        isSelected
                            ? selectedSymptoms.remove(item['id'])
                            : selectedSymptoms.add(item['id']);
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blue.withValues(alpha: 0.1)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: isSelected
                                ? Colors.blue
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getIconData(item['icon_name']),
                              color: isSelected ? Colors.blue : Colors.grey,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              item['title'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                if (selectedSymptoms.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blue, width: 1),
                    ),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.analytics, color: Colors.blue, size: 20),
                            SizedBox(width: 8),
                            Text(
                              "التشخيص المبدئي الفوري:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _calculateDiagnosis(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "حفظ البيانات وإظهار التشخيص النهائي",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
