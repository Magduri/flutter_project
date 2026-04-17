import 'package:flutter/material.dart';
import 'patient_info_screen.dart';

class PatientSearchDelegate extends SearchDelegate {
  final List<dynamic> patientsList;

  PatientSearchDelegate(this.patientsList);

  @override
  String get searchFieldLabel => 'Search by patient name...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; 
        },
      ),
    ];
  }

  
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); 
      },
    );
  }

  //SEARCH LOGIC 
  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

 
  Widget _buildSearchResults() {
    final filteredPatients = patientsList.where((patient) {
      final String firstName = patient['first_name'] ?? patient['firstName'] ?? '';
      final String lastName = patient['last_name'] ?? patient['lastName'] ?? '';
      final String fullName = '$firstName $lastName'.toLowerCase();
      
      return fullName.contains(query.toLowerCase());
    }).toList();

    if (filteredPatients.isEmpty) {
      return const Center(
        child: Text('No patients found.', style: TextStyle(color: Colors.grey, fontSize: 16)),
      );
    }

    return ListView.builder(
      itemCount: filteredPatients.length,
      itemBuilder: (context, index) {
        final patient = filteredPatients[index];
        final String firstName = patient['first_name'] ?? patient['firstName'] ?? 'Patient';
        final String lastName = patient['last_name'] ?? patient['lastName'] ?? '';
        final String fullName = '$firstName $lastName'.trim();
        final String gender = patient['gender'] ?? 'Unknown';

        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: Color(0xFFE0F2F1),
            child: Icon(Icons.person, color: Color(0xFF00796B)),
          ),
          title: Text(fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('Gender: $gender'),
          onTap: () {
            final patientData = <String, String>{
              '_id': patient['_id'].toString(),
              'name': fullName,
              'gender': gender,
              'status': (patient['status'] ?? 'Stable').toString(),
              'dob': (patient['dob'] ?? 'Unknown').toString(),
              'phone': (patient['phone'] ?? 'Unknown').toString(),
              'email': (patient['email'] ?? 'Unknown').toString(),
            };
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PatientInfoScreen(patientData: patientData)),
            );
          },
        );
      },
    );
  }
}