import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkManager {
  //SINGLETON PATTERN
  static final NetworkManager instance = NetworkManager._internal();

  NetworkManager._internal();
  final String _baseUrl = 'http://127.0.0.1:3000';

  Future<List<dynamic>> getPatients() async {
    final response = await http.get(Uri.parse('$_baseUrl/patients'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load patients');
    }
  }

  Future<List<dynamic>> getPatientRecords(String patientId) async {
    final response = await http.get(Uri.parse('$_baseUrl/clinicaldata/patients/$patientId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load records');
    }
  }

  Future<Map<String, dynamic>> addClinicalRecord(Map<String, dynamic> recordData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/clinicaldata'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(recordData),
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      return {
        'success': true,
        'flagged': responseData['flagged'] == true, 
      };
    } else {
      return {'success': false, 'flagged': false};
    }
  }
}