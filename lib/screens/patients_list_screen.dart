import 'package:flutter/material.dart';
//import 'dart:convert'; 
import '../services/network_manager.dart';
import 'patient_info_screen.dart';
import 'patient_search_delegate.dart';
import 'add_patient_screen.dart';

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
      final data = await NetworkManager.instance.getPatients();
      
      setState(() {
        _patients = data;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching patients: $e");
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
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PatientSearchDelegate(_patients),
              );
            },
          ),
        ],
      ),
      
     // --- WRAPPED IN A COLUMN ---
      body: Column(
        children: [
          // 1. The Add Patient Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00796B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 2,
                ),
                icon: const Icon(Icons.person_add, color: Colors.white),
                label: const Text(
                  'Add New Patient',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddPatientScreen(),
                    ),
                  ).then((_) {
                    setState(() => _isLoading = true);
                    fetchPatients();
                  });
                },
              ),
            ),
          ),

          // 2. The Scrollable Patient List
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF00796B)))
              : _patients.isEmpty
                  ? const Center(child: Text("No patients found.", style: TextStyle(fontSize: 16, color: Colors.grey)))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Adjusted padding
                      itemCount: _patients.length,
                      itemBuilder: (context, index) {
                        final patient = _patients[index];
              
                final String firstName = patient['firstName'] ?? 'Patient';
                final String lastName = patient['lastName'] ?? '';
                final String fullName = '$firstName $lastName'.trim();
                final String gender = patient['gender'] ?? 'Unknown';
                final String dob = patient['dob'] ?? 'Unknown';
                final String phone = patient['phone'] ?? 'Unknown';
                final String email = patient['email'] ?? 'Unknown';
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
                        'dob': dob,
                        'phone': phone,
                        'email': email,
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
          ),
        ],
      )
    );
  }
}