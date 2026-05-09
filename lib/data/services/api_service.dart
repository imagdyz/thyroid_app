import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Use 10.0.2.2 for Android Emulator, or your local network IP (e.g., 192.168.1.x), or your production URL
  static const String baseUrl = 'https://magdy.host/5555/backend/api';

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      print('LOGIN STATUS: ${response.statusCode}');
      print('LOGIN BODY: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('user_id', int.parse(data['user']['id'].toString()));
          await prefs.setString('user_name', data['user']['name'].toString());
        }
        return data;
      } else {
        return {'status': 'error', 'message': 'HTTP ${response.statusCode}: ${response.body}'};
      }
    } catch (e) {
      print('LOGIN EXCEPTION: $e');
      return {'status': 'error', 'message': 'Exception: $e'};
    }
  }

  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register.php'),
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      print('REGISTER STATUS: ${response.statusCode}');
      print('REGISTER BODY: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'status': 'error', 'message': 'HTTP ${response.statusCode}: ${response.body}'};
      }
    } catch (e) {
      print('REGISTER EXCEPTION: $e');
      return {'status': 'error', 'message': 'Exception: $e'};
    }
  }

  static Future<List<dynamic>> getSymptoms() async {
    final response = await http.get(Uri.parse('$baseUrl/get_symptoms.php'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        return data['data'];
      }
    }
    return [];
  }

  static Future<Map<String, dynamic>> saveDiagnosis(
    List<String> symptoms,
    String result, {
    String patientName = '',
    String patientPhone = '',
    String patientAge = '',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      return {'status': 'error', 'message': 'User not logged in'};
    }

    final response = await http.post(
      Uri.parse('$baseUrl/save_diagnosis.php'),
      body: jsonEncode({
        'user_id': userId,
        'symptoms': symptoms,
        'diagnosis_result': result,
        'patient_name': patientName,
        'patient_phone': patientPhone,
        'patient_age': patientAge,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {'status': 'error', 'message': 'Network error'};
    }
  }

  static Future<List<dynamic>> getDiagnoses({int? limit}) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) return [];

    String url = '$baseUrl/get_diagnoses.php?user_id=$userId';
    if (limit != null) {
      url += '&limit=$limit';
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return data['data'];
        }
      }
    } catch (e) {
      print('GET DIAGNOSES EXCEPTION: $e');
    }
    return [];
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_name');
  }
}