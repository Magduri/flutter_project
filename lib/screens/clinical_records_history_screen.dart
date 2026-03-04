import 'package:flutter/material.dart';
// import 'dart:convert';
import '../services/network_manager.dart';
import 'add_clinical_record_screen.dart';

class ClinicalRecordsHistoryScreen extends StatefulWidget {
  final String patientId;
  final String patientName;

  const ClinicalRecordsHistoryScreen({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  State<ClinicalRecordsHistoryScreen> createState() => _ClinicalRecordsHistoryScreenState();
}

class _ClinicalRecordsHistoryScreenState extends State<ClinicalRecordsHistoryScreen> {
  List<dynamic> _records = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecords();
  }

  // Fetch the records 
  Future<void> fetchRecords() async {
    try {
      final data = await NetworkManager.instance.getPatientRecords(widget.patientId);
      setState(() {
        _records = data;
        _isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text('${widget.patientName} - Records', 
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF00796B),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Record',
            onPressed: () {
              print("Open Add Record Screen");
            },
          )
        ],
      ),
      
       
      body: Column(
        children: [
          
          // THE RECORDS LIST 
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF00796B)))
                : _records.isEmpty
                    ? const Center(
                        child: Text(
                          "No clinical records found.\nAdd a new test to get started.", 
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 16)
                        )
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _records.length,
                        itemBuilder: (context, index) {
                          final record = _records[index];
                          
                          
                          final String testType = record['type'] ?? 'Unknown Test';
                          final String testValue = record['value']?.toString() ?? 'N/A';
                          final String classification = record['classification'] ?? 'Unknown';
                          
                         
                          final bool isCritical = (classification == 'High' || classification == 'Low');

                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 12.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isCritical ? const Color(0xFFFFEBEE) : const Color(0xFFE0F2F1), 
                                child: Icon(
                                  Icons.favorite, 
                                  color: isCritical ? Colors.redAccent : const Color(0xFF00796B)
                                ),
                              ),
                             
                              title: Text(testType, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  "Result: $testValue   •   Status: $classification",
                                  style: TextStyle(
                                    color: isCritical ? Colors.red.shade700 : Colors.grey.shade600,
                                    fontWeight: isCritical ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                            ),
                          );
                        },
                      ),
          ),
          
          //BOTTOM BUTTON
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]
            ),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00796B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.add_chart, color: Colors.white),
                label: const Text('Add New Test Record', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                onPressed: () async {
               
               final result = await Navigator.push(
                 context,
                 MaterialPageRoute(
                   builder: (context) => AddClinicalRecordScreen(patientId: widget.patientId),
                 ),
               );

               if (result == true) {
                 setState(() => _isLoading = true);
                 fetchRecords();
               }
             },
              ),
            ),
          )
        ],
      ),
    );
  }
}