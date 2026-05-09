import 'package:flutter/material.dart';
import '../../../data/services/api_service.dart';

class PatientScreen extends StatefulWidget {
  final String diagnosisResult;
  final List<String> selectedSymptoms;
  final List<String> symptomNames;

  const PatientScreen({
    super.key,
    required this.diagnosisResult,
    required this.selectedSymptoms,
    required this.symptomNames,
  });

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await ApiService.saveDiagnosis(
        widget.selectedSymptoms,
        widget.diagnosisResult,
        patientName: nameController.text.trim(),
        patientPhone: phoneController.text.trim(),
        patientAge: ageController.text.trim(),
      );

      if (!mounted) return;

      if (response['status'] == 'success') {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Column(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 60),
                SizedBox(height: 10),
                Text("تم الحفظ بنجاح", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            content: const Text(
              "تم حفظ بيانات المريض ونتيجة التشخيص بنجاح",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text("موافق", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? "حدث خطأ")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("خطأ في الاتصال بالخادم")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("بيانات المريض"),
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Diagnosis Result Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
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
                            Icon(Icons.medical_information, color: Colors.blue, size: 24),
                            SizedBox(width: 8),
                            Text(
                              "نتيجة التشخيص",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.diagnosisResult,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  _buildTreatmentCard(),

                  const SizedBox(height: 15),

                  // Selected Symptoms
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.list_alt, color: Colors.orange, size: 20),
                            SizedBox(width: 8),
                            Text(
                              "الأعراض المختارة:",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: widget.symptomNames.map((name) =>
                            Chip(
                              label: Text(name, style: const TextStyle(fontSize: 12)),
                              backgroundColor: Colors.orange.withValues(alpha: 0.2),
                            ),
                          ).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Patient Info Section
                  const Text(
                    "البيانات الشخصية",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: nameController,
                    validator: (val) => val == null || val.isEmpty ? "مطلوب" : null,
                    decoration: const InputDecoration(
                      labelText: "اسم المريض",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (val) => val == null || val.isEmpty ? "مطلوب" : null,
                    decoration: const InputDecoration(
                      labelText: "رقم الموبايل",
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    validator: (val) => val == null || val.isEmpty ? "مطلوب" : null,
                    decoration: const InputDecoration(
                      labelText: "العمر",
                      prefixIcon: Icon(Icons.cake),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "حفظ البيانات",
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTreatmentCard() {
    String diagnosis = widget.diagnosisResult;
    if (diagnosis.contains("خمول")) {
      return _buildTreatmentContent(
        title: "بروتوكول العلاج المقترح",
        drugs: "ليفوثيروكسين (Levothyroxine) مثل: (Euthyrox) أو (Thyroxin).",
        diet: "المأكولات البحرية، البيض، والجوز البرازيلي (لسد احتياج السيلينيوم).",
        warning: "يفضل تناول الخضروات الصليبية (مثل الكرنب والبروكلي) مطبوخة وليست نيئة.",
      );
    } else if (diagnosis.contains("فرط نشاط")) {
      return _buildTreatmentContent(
        title: "بروتوكول العلاج المقترح",
        drugs: "كاربيمازول (Carbimazole) أو ميثيمازول (Methimazole).\nأدوية مساعدة: مثبطات بيتا (مثل Inderal) لتهدئة ضربات القلب.",
        diet: "الخضروات الصليبية (البروكلي والقرنبيط)، الأطعمة الغنية بالكالسيوم، والدهون الصحية (زيت الزيتون).",
        warning: "يفضل تجنب الملح المدعم باليود والمأكولات البحرية، وتقليل الكافيين.",
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildTreatmentContent({
    required String title,
    required String drugs,
    required String diet,
    required String warning,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.green.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.healing, color: Colors.green, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text("الأدوية المقترحة (يرجى مراجعة الطبيب):", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 4),
          Text(drugs, style: const TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 12),
          const Text("النظام الغذائي الموصى به:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 4),
          Text(diet, style: const TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "تنبيه: $warning",
                    style: const TextStyle(fontSize: 13, color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
