import 'package:flutter/material.dart';
import 'dart:convert'; 
import 'package:http/http.dart' as http; 
import 'patient_info_screen.dart';

class PatientsListScreen extends StatefulWidget {
  const PatientsListScreen({super.key});

  @override
  State<PatientsListScreen> createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends State<PatientsListScreen> {
  
  List<dynamic> _patients = [];
  bool _isLoading = true; 

  @override
  void initState() {
    super.initState();
    fetchPatients(); 
  }

 
  Future<void> fetchPatients() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:3000/patients'));

      if (response.statusCode == 200) {
        setState(() {
          _patients = json.decode(response.body);
          _isLoading = false; 
        });
      } else {
        print("Server error: ${response.statusCode}");
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("Network error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Patient List', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF00796B),
        elevation: 0,
      ),
      
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00796B)))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _patients.length,
              itemBuilder: (context, index) {
                final patient = _patients[index];

              
                final String firstName = patient['first_name'] ?? patient['firstName'] ?? 'Patient';
                final String lastName = patient['last_name'] ?? patient['lastName'] ?? '';
                final String fullName = '$firstName $lastName'.trim();
                final String gender = patient['gender'] ?? 'Unknown';
                
            
                final String status = patient['status'] ?? 'Stable'; 

                return Card(
                  elevation: 2, 
                  margin: const EdgeInsets.only(bottom: 12.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFE0F2F1),
                      child: Text(
                        fullName.isNotEmpty ? fullName[0].toUpperCase() : '?', 
                        style: const TextStyle(color: Color(0xFF00796B), fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      fullName, 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Status: $status • $gender',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () {
                      final patientData = {
                        '_id': patient['_id'].toString(),
                        'name': fullName,
                        'gender': gender,
                        'status': status,
                      };
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientInfoScreen(patientData: patientData),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}