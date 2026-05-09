import 'package:flutter/material.dart';
import '../../../data/services/api_service.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  bool _isLoading = true;
  List<dynamic> _records = [];

  @override
  void initState() {
    super.initState();
    _fetchRecords();
  }

  Future<void> _fetchRecords() async {
    setState(() => _isLoading = true);
    final records = await ApiService.getDiagnoses();
    setState(() {
      _records = records;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _records.isEmpty
                ? const Center(child: Text("لا توجد سجلات حالياً"))
                : RefreshIndicator(
                    onRefresh: _fetchRecords,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _records.length,
                      itemBuilder: (context, index) {
                        final record = _records[index];
                        return _buildRecordCard(record);
                      },
                    ),
                  ),
      ),
    );
  }

  Widget _buildRecordCard(Map<String, dynamic> record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  record['patient_name'] ?? "مريض غير معروف",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              Text(
                _formatDate(record['created_at']),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.phone, size: 16, color: Colors.grey),
              const SizedBox(width: 5),
              Text(record['patient_phone'] ?? "بدون رقم", style: const TextStyle(color: Colors.black87)),
              const SizedBox(width: 15),
              const Icon(Icons.cake, size: 16, color: Colors.grey),
              const SizedBox(width: 5),
              Text("${record['patient_age'] ?? '--'} سنة", style: const TextStyle(color: Colors.black87)),
            ],
          ),
          const Divider(height: 20),
          Row(
            children: [
              const Icon(Icons.medical_services_outlined, size: 18, color: Colors.orange),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  record['diagnosis_result'] ?? "",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return "";
    try {
      final date = DateTime.parse(dateStr);
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return dateStr;
    }
  }
}
