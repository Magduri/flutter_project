import 'package:flutter/material.dart';
import 'clinical_records_history_screen.dart';

class PatientInfoScreen extends StatelessWidget {
  
  final Map<String, dynamic> patientData;

  const PatientInfoScreen({super.key, required this.patientData});

 @override
  Widget build(BuildContext context) {
    
    final String firstName = patientData['firstName']?.toString() ?? '';
    final String lastName = patientData['lastName']?.toString() ?? '';
    
    String displayName = patientData['name']?.toString() ?? '';
    
    if (displayName.isEmpty) {
      displayName = "$firstName $lastName".trim();
    }
    
    // Safety check for the Avatar initial
    final String initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

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
                  initial, 
                  style: const TextStyle(fontSize: 40, color: Color(0xFF00796B), fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              displayName.isEmpty ? 'Unknown Patient' : displayName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
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
                      subtitle: Text(patientData['gender'] ?? 'N/A'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.calendar_today, color: Color(0xFF00796B)),
                      title: const Text('Date of Birth'),
                      subtitle: Text(patientData['dob'] ?? 'N/A'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone, color: Color(0xFF00796B)),
                      title: const Text('Phone'),
                      subtitle: Text(patientData['phone'] ?? 'N/A'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email, color: Color(0xFF00796B)),
                      title: const Text('Email'),
                      subtitle: Text(patientData['email'] ?? 'N/A'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 90),

           // --- CLINICAL RECORDS BUTTON ---
            
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00796B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.history_edu, color: Colors.white), 
                  label: const Text('View Clinical Records', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  onPressed: () {
                   final id = patientData['_id']?.toString();
                   if (id != null) {
                     Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) => ClinicalRecordsHistoryScreen(
                           patientId: id, 
                           patientName: displayName,
                         ),
                       ),
                     );
                   } else {
                     ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(content: Text("Error: Patient ID is missing"))
                     );
                   }
                 },
                ),
              ),
          ],
        ),
      ),
    );
  }
}