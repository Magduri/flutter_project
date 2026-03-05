import 'package:flutter/material.dart';
import '../services/network_manager.dart';
import 'clinical_records_history_screen.dart';

class CriticalPatientsScreen extends StatefulWidget {
  const CriticalPatientsScreen({super.key});

  @override
  State<CriticalPatientsScreen> createState() => _CriticalPatientsScreenState();
}

class _CriticalPatientsScreenState extends State<CriticalPatientsScreen> {
  List<dynamic> _criticalPatients = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCriticalList();
  }

  Future<void> _fetchCriticalList() async {
    try {
      final data = await NetworkManager.instance.getCriticalPatients();
      setState(() {
        _criticalPatients = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFEBEE), 
      appBar: AppBar(
        title: const Text('CRITICAL TRIAGE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
        backgroundColor: Colors.red.shade800, 
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.red.shade800))
          : _criticalPatients.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline, size: 100, color: Colors.green.shade400),
                      const SizedBox(height: 16),
                      const Text("No critical patients.", style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _criticalPatients.length,
                  itemBuilder: (context, index) {
                    final patient = _criticalPatients[index];
                    
                    //PARSE THE CRITICAL DATA
                    final record = patient['latestRecord']; 
                    final String type = record['type'] ?? 'Unknown Risk';
                    final String value = record['value']?.toString() ?? 'N/A';
                    
                    final String firstName = patient['first_name'] ?? patient['firstName'] ?? 'Patient';
                    final String lastName = patient['last_name'] ?? patient['lastName'] ?? '';
                    final String fullName = '$firstName $lastName'.trim();

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.red.shade300, width: 1.5), 
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: Colors.red.shade100,
                          radius: 25,
                          child: Icon(Icons.warning_amber_rounded, color: Colors.red.shade900, size: 30),
                        ),
                        title: Text(fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.red.shade200)
                                ),
                                child: Text(
                                  "$type: $value", 
                                  style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClinicalRecordsHistoryScreen(
                                patientId: patient['_id'],
                                patientName: fullName,
                              ),
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