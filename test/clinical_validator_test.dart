import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project/utils/clinical_validator.dart'; 

void main() {
  
  group('Heart Rate Validation Tests', () {
    
    test('Returns error if heart rate is dangerously low', () {
      final result = ClinicalValidator.validateSingleValueTest('Heart Rate', '10');
      expect(result, 'Heart rate must be between 20 and 300 bpm.');
    });

    test('Returns error if heart rate is dangerously high', () {
      final result = ClinicalValidator.validateSingleValueTest('Heart Rate', '350');
      expect(result, 'Heart rate must be between 20 and 300 bpm.');
    });

    test('Returns null (success) for a normal, healthy heart rate', () {
      final result = ClinicalValidator.validateSingleValueTest('Heart Rate', '80');
      expect(result, null);
    });
    
  });

  group('Blood Pressure Validation Tests', () {
    
    test('Returns error if Diastolic is higher than Systolic (Impossible reading)', () {
      final result = ClinicalValidator.validateBloodPressure('80', '120');
      expect(result, 'Systolic must be higher than Diastolic.');
    });

    test('Returns null (success) for a normal blood pressure', () {
      final result = ClinicalValidator.validateBloodPressure('120', '80');
      expect(result, null);
    });

  });


group('SPO2 and Respiratory Rate Tests', () {
    
    test('Returns error if SPO2 is impossibly low', () {
      final result = ClinicalValidator.validateSingleValueTest('SPO2', '20');
      expect(result, 'SPO2 must be between 30% and 100%.');
    });

    test('Returns null (success) for healthy SPO2', () {
      final result = ClinicalValidator.validateSingleValueTest('SPO2', '98');
      expect(result, null);
    });

    test('Returns error if Respiratory Rate is too high', () {
      final result = ClinicalValidator.validateSingleValueTest('Respiratory Rate', '80');
      expect(result, 'Respiratory rate must be between 5 and 70.');
    });

  });

}