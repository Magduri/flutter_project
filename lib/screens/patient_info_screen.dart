import 'package:flutter/material.dart';
import 'clinical_records_history_screen.dart';

class PatientInfoScreen extends StatelessWidget {
  
  final Map<String, String> patientData;

  const PatientInfoScreen({super.key, required this.patientData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Patient Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF00796B),
        iconTheme: const IconThemeData(color: Colors.white), 
        elevation: 0,
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // --- PROFILE HEADER ---
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xFFE0F2F1),
                child: Text(
                  patientData['name']![0], 
                  style: const TextStyle(fontSize: 40, color: Color(0xFF00796B), fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              patientData['name']!,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
            ),
            Text(
              'Status: ${patientData['status']}',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 30),

            // --- RECORDS SECTION ---
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Basic Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.person, color: Color(0xFF00796B)),
                      title: const Text('Gender'),
                      subtitle: Text(patientData['gender']!),
                    ),
                    ListTile(
                      leading: const Icon(Icons.calendar_today, color: Color(0xFF00796B)),
                      title: const Text('Age'),
                      subtitle: Text(patientData['age']!),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone, color: Color(0xFF00796B)),
                      title: const Text('Phone'),
                      subtitle: Text(patientData['phone']!),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email, color: Color(0xFF00796B)),
                      title: const Text('Email'),
                      subtitle: Text(patientData['email']!),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

           // --- CLINICAL RECORDS BUTTON ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00796B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                //icon: const Icon(Icons.history_edu, color: Colors.white), 
                label: const Text('View Clinical Records', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
               onPressed: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(
                   builder: (context) => ClinicalRecordsHistoryScreen(
                     patientId: patientData['_id']!, 
                     patientName: patientData['name']!,
                   ),
                 ),
               );
             },
              ),
            ),
          ],
        ),
      ),
    );
  }
}