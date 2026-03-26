import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NetworkManager {
  //SINGLETON PATTERN
  static final NetworkManager instance = NetworkManager._internal();

  NetworkManager._internal();

  // Android emulator cannot access host machine via 127.0.0.1.
  String get _baseUrl {
    if (kIsWeb) return 'http://127.0.0.1:3000';
    if (Platform.isAndroid) return 'http://10.0.2.2:3000';
    return 'http://127.0.0.1:3000';
  }

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

  Future<List<dynamic>> getCriticalPatients() async {
    final response = await http.get(Uri.parse('$_baseUrl/patients/critical'));
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load critical patients');
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

  // --- NEW LOGIN METHOD ---
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'email': email,
          'username': email,
          'password': password
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        dynamic decoded;
        try {
          decoded = json.decode(response.body);
        } catch (_) {
          decoded = null;
        }

        final backendMessage = decoded is Map<String, dynamic>
            ? (decoded['message'] ?? decoded['error'])
            : null;

        return {
          'success': false,
          'message': backendMessage?.toString() ??
              'Login failed (HTTP ${response.statusCode}).',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error occurred: $e'};
    }
  }

  Future<Map<String, dynamic>> addPatient(Map<String, dynamic> patientData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/patients'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(patientData),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add patient');
    }
  }
}