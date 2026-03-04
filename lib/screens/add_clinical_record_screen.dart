import 'package:flutter/material.dart';
//import 'dart:convert';
import '../services/network_manager.dart';

class AddClinicalRecordScreen extends StatefulWidget {
  final String patientId;

  const AddClinicalRecordScreen({super.key, required this.patientId});

  @override
  State<AddClinicalRecordScreen> createState() => _AddClinicalRecordScreenState();
}

class _AddClinicalRecordScreenState extends State<AddClinicalRecordScreen> {
  final List<String> _testTypes = ['Blood Pressure', 'Heart Rate', 'Respiratory Rate', 'SPO2'];
  String _selectedType = 'Blood Pressure'; 
  
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();
  
  bool _isSubmitting = false;

  String _getUnitSuffix() {
    switch (_selectedType) {
      case 'Heart Rate': return 'bpm';
      case 'Respiratory Rate': return 'breaths/min';
      case 'SPO2': return '%';
      default: return '';
    }
  }

  // Helper function to show errors easily
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ), 
        backgroundColor: Colors.red.shade800,
        behavior: SnackBarBehavior.floating, 
      ),
    );
  }

  Future<void> _submitRecord() async {
    String finalValue = "";

   
    //VALIDATION LOGIC
    if (_selectedType == 'Blood Pressure') {
      if (_systolicController.text.trim().isEmpty || _diastolicController.text.trim().isEmpty) {
        return _showError('Please enter both Systolic and Diastolic values.');
      }
      
      int? sys = int.tryParse(_systolicController.text.trim());
      int? dia = int.tryParse(_diastolicController.text.trim());
      
      if (sys == null || dia == null) return _showError('Blood pressure must be valid whole numbers.');
      if (sys < 50 || sys > 250) return _showError('Systolic value must be between 50 and 250.');
      if (dia < 30 || dia > 150) return _showError('Diastolic value must be between 30 and 150.');
      if (sys <= dia) return _showError('Systolic must be higher than Diastolic.');

      finalValue = "$sys/$dia";

    } else {
      if (_valueController.text.trim().isEmpty) return _showError('Please enter a test value.');

      int? val = int.tryParse(_valueController.text.trim());
      if (val == null) return _showError('Value must be a valid number.');

      if (_selectedType == 'Heart Rate' && (val < 20 || val > 300)) return _showError('Heart rate must be between 20 and 300 bpm.');
      if (_selectedType == 'Respiratory Rate' && (val < 5 || val > 70)) return _showError('Respiratory rate must be between 5 and 70.');
      if (_selectedType == 'SPO2' && (val < 30 || val > 100)) return _showError('SPO2 must be between 30% and 100%.');

      finalValue = val.toString();
    }
    

    setState(() => _isSubmitting = true);

    try {
      final Map<String, dynamic> requestBody = {
        "patientId": widget.patientId,
        "type": _selectedType,
        "value": finalValue, 
      };

      final response = await NetworkManager.instance.addClinicalRecord(requestBody);

     
      //CRITICAL ALERT
      if (response['statusCode'] == 201) {
        final bool isCritical = response['flagged'] == true;

        if (mounted) setState(() => _isSubmitting = false);

        if (isCritical && mounted) {
          await showDialog(
            context: context,
            barrierDismissible: false, 
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                backgroundColor: const Color(0xFFFFEBEE), 
                title: const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.red, size: 32),
                    SizedBox(width: 10),
                    Text('CRITICAL VALUE', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ],
                ),
                content: Text(
                  'The $_selectedType reading of $finalValue is at a critical level.\n\nProtocol requires immediate notification of the attending physician or rapid response team.',
                  style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.4),
                ),
                actions: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => Navigator.of(context).pop(), 
                      child: const Text('Acknowledge & Notify', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              );
            },
          );
        }

        
        if (mounted) Navigator.pop(context, true); 
        
      } else {
        _showError('Server Error: Failed to save record.');
      }
    } catch (e) {
      _showError('Network error occurred. Check your connection.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Add Test Record', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF00796B),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.health_and_safety, color: Color(0xFF00796B)),
                      SizedBox(width: 10),
                      Text('Clinical Data', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 30),
                  
                  const Text('Test Type', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF00796B)),
                        value: _selectedType,
                        items: _testTypes.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type, style: const TextStyle(fontSize: 16)),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedType = newValue!;
                            _valueController.clear();
                            _systolicController.clear();
                            _diastolicController.clear();
                          });
                        },
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),

                  const Text('Result Value', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 8),
                  
                  if (_selectedType == 'Blood Pressure') ...[
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _systolicController,
                            keyboardType: TextInputType.number, 
                            decoration: InputDecoration(
                              labelText: 'Systolic',
                              hintText: '120',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              prefixIcon: const Icon(Icons.arrow_upward, size: 18, color: Colors.redAccent),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('/', style: TextStyle(fontSize: 24, color: Colors.grey, fontWeight: FontWeight.w300)),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _diastolicController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Diastolic',
                              hintText: '80',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              prefixIcon: const Icon(Icons.arrow_downward, size: 18, color: Colors.blueAccent),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    TextField(
                      controller: _valueController,
                      keyboardType: TextInputType.number, 
                      decoration: InputDecoration(
                        hintText: 'Enter numerical value',
                        suffixText: _getUnitSuffix(), 
                        suffixStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00796B)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                  ],

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00796B),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _isSubmitting ? null : _submitRecord,
                      child: _isSubmitting 
                          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Save Clinical Record', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}