class ClinicalValidator {
  
  static String? validateBloodPressure(String sysText, String diaText) {
    if (sysText.trim().isEmpty || diaText.trim().isEmpty) return 'Please enter both Systolic and Diastolic values.';
    
    int? sys = int.tryParse(sysText.trim());
    int? dia = int.tryParse(diaText.trim());
    
    if (sys == null || dia == null) return 'Blood pressure must be valid whole numbers.';
    if (sys < 50 || sys > 250) return 'Systolic value must be between 50 and 250.';
    if (dia < 30 || dia > 150) return 'Diastolic value must be between 30 and 150.';
    if (sys <= dia) return 'Systolic must be higher than Diastolic.';
    
    return null; // Passed!
  }

  static String? validateSingleValueTest(String type, String valueText) {
    if (valueText.trim().isEmpty) return 'Please enter a test value.';

    int? val = int.tryParse(valueText.trim());
    if (val == null) return 'Value must be a valid number.';

    if (type == 'Heart Rate' && (val < 20 || val > 300)) return 'Heart rate must be between 20 and 300 bpm.';
    if (type == 'Respiratory Rate' && (val < 5 || val > 70)) return 'Respiratory rate must be between 5 and 70.';
    if (type == 'SPO2' && (val < 30 || val > 100)) return 'SPO2 must be between 30% and 100%.';

    return null; // Passed!
  }
}