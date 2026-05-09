import 'package:flutter/material.dart';
class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});
  @override
  State<AnalysisScreen> createState() => _SymptomsPageState();
}
class _SymptomsPageState extends State<AnalysisScreen> {
  final TextEditingController valueController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  String? selectedAnalysis;
  String? resultMessage;
  Color? resultColor;
  final List<String> analysisTypes = [
    "هرمون TSH",
    "T4 الحر (Free T4)",
    "T3 الحر (Free T3)",
  ];
  String _getUnit() {
    if (selectedAnalysis == "هرمون TSH") return "mIU/L";
    if (selectedAnalysis == "T4 الحر (Free T4)") return "ng/dL";
    if (selectedAnalysis == "T3 الحر (Free T3)") return "pg/mL";
    return "";
  }
  void _calculateResult() {
    setState(() {
      if (selectedAnalysis == null || valueController.text.isEmpty) {
        resultMessage = "الرجاء اختيار نوع التحليل وإدخال القيمة.";
        resultColor = Colors.orange;
        return;
      }
      double? value = double.tryParse(valueController.text);
      if (value == null) {
        resultMessage = "الرجاء إدخال رقم صحيح.";
        resultColor = Colors.red;
        return;
      }
      if (selectedAnalysis == "هرمون TSH") {
        if (value >= 0.4 && value <= 4.0) {
          resultMessage =
              "النتيجة طبيعية (بين 0.4 : 4.0). لا توجد مؤشرات على مشاكل في الغدة الدرقية.";
          resultColor = Colors.green;
        } else if (value < 0.4) {
 resultMessage =
"في حالة نشاط: النسبة أقل من 0.4 (الجسم يوقف الطلب لوجود فائض). قد يشير ذلك إلى فرط نشاط الغدة الدرقية.";
resultColor = Colors.red;
 } else {
          resultMessage =
              "في حالة خمول: النسبة أعلى من 4.0 (الجسم يصرخ لطلب الهرمونات). قد يشير ذلك إلى قصور في الغدة الدرقية.";
          resultColor = Colors.red;
        }
      } else if (selectedAnalysis == "T4 الحر (Free T4)") {
        if (value >= 0.9 && value <= 1.7) {
          resultMessage =
              "النتيجة طبيعية (بين 0.9 : 1.7). هو الهرمون الأساسي الذي تنتجه الغدة الدرقية.";
          resultColor = Colors.green;
        } else if (value < 0.9) {
          resultMessage = "في حالة خمول: النسبة أقل من 0.9.";
          resultColor = Colors.red;
        } else {
          resultMessage = "في حالة نشاط: النسبة أعلى من 1.7.";
          resultColor = Colors.red;
        }
      }
      else if (selectedAnalysis == "T3 الحر (Free T3)") {
  if (value < 2.0) {
    resultMessage = "النسبة منخفضة. قد يشير ذلك إلى خمول في الغدة الدرقية، يُفضل مراجعة الطبيب.";
    resultColor = Colors.orange;
  } else if (value >= 2.0 && value <= 4.4) {
    resultMessage = "النتيجة طبيعية. وظائف الغدة الدرقية ضمن المعدل الطبيعي.";
    resultColor = Colors.green;
  } else {
    resultMessage = "النسبة مرتفعة. قد يشير ذلك إلى نشاط زائد في الغدة الدرقية، يُفضل استشارة الطبيب.";
    resultColor = Colors.red;
  }
}
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.help_outline, color: Colors.blue),
        title: const Text(
          "نتيجة التحليل",
          style: TextStyle(
            color: Color(0xFF003399),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // أيقونة وعنوان القسم
              const Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.science_outlined,
                      color: Color(0xFF003399),
                      size: 30,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "نتائج فحص الغدة الدرقية",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003399),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "نوع التحليل",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text("اختر نوع التحليل"),
                    value: selectedAnalysis,
                    items: analysisTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedAnalysis = newValue;
                        valueController.clear();
                        resultMessage = null;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (selectedAnalysis != null) ...[
                _buildInputField(
                  selectedAnalysis!,
                  _getUnit(),
                  valueController,
                ),
              ],
              const SizedBox(height: 20),
              const Text(
                "ملاحظات إضافية",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "أدخل أي ملاحظات سريرية أو أعراض تشعر بها...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "أدخل نتيجة التحليل لمعرفة ما إذا كانت ضمن المعدل الطبيعي. النتائج هي لأغراض إرشادية ويجب استشارة الطبيب للتشخيص.",
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              if (resultMessage != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: resultColor?.withValues(alpha: 0.1),
                    border: Border.all(
                      color: resultColor ?? Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        resultColor == Colors.green
                            ? Icons.check_circle
                            : Icons.warning_amber_rounded,
                        color: resultColor,
                        size: 40,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        resultMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: resultColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
              ],
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1a73e8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _calculateResult,
                  child: const Text(
                    "عرض النتيجة",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildInputField(
    String label,
    String unit,
    TextEditingController controller,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              unit,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.edit, color: Colors.blue, size: 18),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
