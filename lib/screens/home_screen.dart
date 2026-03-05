import 'package:flutter/material.dart';
import 'add_patient_screen.dart'; 
import '../services/network_manager.dart'; 
import 'patient_info_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _criticalPatients = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    try {
      final data = await NetworkManager.instance.getCriticalPatients();
      if (mounted) {
        setState(() {
          _criticalPatients = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      
      appBar: AppBar(
        toolbarHeight: 100.0,
        title: const Text(
          'Welcome Back!',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF00796B),
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1, color: Colors.white, size: 28),
            tooltip: 'Add New Patient',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPatientScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
            
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30), 
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade200, blurRadius: 5, spreadRadius: 1)
                  ]
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search patient by name...',
                    prefixIcon: Icon(Icons.search, color: Color(0xFF00796B)),
                    border: InputBorder.none, 
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              
              const SizedBox(height: 35),

              
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.red.shade100,
                    radius: 30,
                    child: Icon(Icons.warning_amber_rounded, color: Colors.red.shade900, size: 30),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Attention Needed',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE53935),
                    ),
                  ),
                ],
              ), 
              
              const SizedBox(height: 15),

              
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _criticalPatients.isEmpty
                      ? const Text("All patients are currently stable.", style: TextStyle(color: Colors.green, fontSize: 16))
                      : ListView.builder(
                          shrinkWrap: true, 
                          physics: const NeverScrollableScrollPhysics(), 
                          itemCount: _criticalPatients.length,
                          itemBuilder: (context, index) {
                            final patient = _criticalPatients[index];
                            final record = patient['latestRecord'];
                            
                            final String fName = patient['firstName'] ?? patient['first_name'] ?? '';
                            final String lName = patient['lastName'] ?? patient['last_name'] ?? '';
                            final String fullName = patient['name'] ?? "$fName $lName".trim();
                            
                            final String type = record['type'] ?? 'Unknown';
                            final String value = record['value']?.toString() ?? 'N/A';

                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.only(bottom: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.red.shade100, 
                                  child: Icon(Icons.warning_amber_rounded, color: Colors.red.shade900),
                                ),
                                title: Text(fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text("$type: $value", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                                onTap: () {
                                   Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PatientInfoScreen(patientData: {
                                        '_id': patient['_id'].toString(),
                                        'name': fullName,
                                        'gender': patient['gender'] ?? 'Unknown',
                                      }),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }
}