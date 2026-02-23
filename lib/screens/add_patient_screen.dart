import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 

// 1. THE FOUNDATION
class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  
  // 2. THE MEMORY (State Variables
  int _selectedGenderIndex = 0; 
  DateTime? _selectedDate; 
  final TextEditingController _dobController = TextEditingController(); 

  // 3. THE HELPER FUNCTION
  Widget _buildTextField(String label, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF00796B)), // Teal icon
          filled: true,
          fillColor: const Color(0xFFF8FAFC), // Light grey background
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none, 
          ),
        ),
      ),
    );
  }

  // 4. THE CALENDAR LOGIC
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('MMM dd, yyyy').format(picked);
      });
    }
  }

  // 5. THE UI CANVAS
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), 
      appBar: AppBar(
        title: const Text('Add Patient', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF00796B),
        iconTheme: const IconThemeData(color: Colors.white), 
        elevation: 0,
      ),
      
      // 6. THE SCROLLABLE BODY 
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        
        // 7. THE VERTICAL STACK
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // --- SECTION 1: PERSONAL DETAILS ---
            const Text('Personal Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
            const SizedBox(height: 10), // Spacing
            
            // 8. THE CARD WIDGET (Creates the white box with a soft shadow)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    // 9. USING OUR HELPER FUNCTION! 
                    _buildTextField('First Name', Icons.person),
                    _buildTextField('Last Name', Icons.person_outline),
                    
                    // 10. THE DATE OF BIRTH FIELD
                    TextField(
                      controller: _dobController, 
                      readOnly: true, 
                      onTap: () => _selectDate(context), 
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF00796B)),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // 11. THE GENDER TOGGLE BUTTONS
                    const Text('Gender', style: TextStyle(fontSize: 14, color: Colors.black54)),
                    const SizedBox(height: 8),
                    Center(
                      child: ToggleButtons(
                        isSelected: [_selectedGenderIndex == 0, _selectedGenderIndex == 1],
                        onPressed: (int index) {
                          setState(() {
                            _selectedGenderIndex = index;
                          });
                        },
                        borderRadius: BorderRadius.circular(10),
                        selectedColor: Colors.white,
                        fillColor: const Color(0xFF00796B),
                        color: Colors.black54,
                        constraints: const BoxConstraints(minHeight: 45, minWidth: 120),
                        children: const [
                          Text('Male', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Female', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            // --- SECTION 2: CONTACT DETAILS ---
            const Text('Contact Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
            const SizedBox(height: 10),
            
            // Another Card for visual grouping
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildTextField('Phone Number', Icons.phone, keyboardType: TextInputType.phone),
                    _buildTextField('Email Address', Icons.email, keyboardType: TextInputType.emailAddress),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 35),

            // --- SECTION 3: THE ACTION BUTTON ---
            SizedBox(
              width: double.infinity, 
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00796B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  // 12. ROUTING: GOING BACK!
                  print("Patient Data Ready to Save!");
                  Navigator.pop(context);
                },
                child: const Text('Register Patient', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}