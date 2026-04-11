import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project/utils/clinical_validator.dart';

typedef _TestBody = FutureOr<void> Function();

class _GroupProgress {
  _GroupProgress(this.name, this.expectedTests);

  final String name;
  final int expectedTests;
  int completedTests = 0;
  bool hasFailure = false;
}

void _groupedTest(_GroupProgress progress, String description, _TestBody body) {
  test(description, () async {
    try {
      await body();
    } catch (_) {
      progress.hasFailure = true;
      rethrow;
    } finally {
      progress.completedTests += 1;
      if (progress.completedTests == progress.expectedTests) {
        final result = progress.hasFailure ? 'failed' : 'passed';
        print('${progress.name} $result.');
      }
    }
  });
}

void main() {
  final heartRateProgress = _GroupProgress('Heart Rate Validation Tests', 2);
  final bloodPressureProgress = _GroupProgress('Blood Pressure Validation Tests', 6);
  final spo2AndRespiratoryProgress = _GroupProgress('SPO2 and Respiratory Rate Tests', 4);

  group('Heart Rate Validation Tests', () {
    _groupedTest(heartRateProgress, 'Returns error if heart rate is dangerously low', () {
      final result = ClinicalValidator.validateSingleValueTest('Heart Rate', '10');
      expect(result, 'Heart rate must be between 20 and 300 bpm.');
    });

    _groupedTest(heartRateProgress, 'Returns success for a normal, healthy heart rate', () {
      final result = ClinicalValidator.validateSingleValueTest('Heart Rate', '80');
      expect(result, null);
    });
  });

  group('Blood Pressure Validation Tests', () {
    _groupedTest(bloodPressureProgress, 'Returns error when both blood pressure inputs are empty', () {
      final result = ClinicalValidator.validateBloodPressure('', '');
      expect(result, 'Please enter both Systolic and Diastolic values.');
    });

    _groupedTest(bloodPressureProgress, 'Returns error when blood pressure values are not whole numbers', () {
      final result = ClinicalValidator.validateBloodPressure('120.5', '80');
      expect(result, 'Blood pressure must be valid whole numbers.');
    });

    _groupedTest(bloodPressureProgress, 'Returns error when systolic is below the supported range', () {
      final result = ClinicalValidator.validateBloodPressure('49', '80');
      expect(result, 'Systolic value must be between 50 and 250.');
    });

    _groupedTest(bloodPressureProgress, 'Returns error when diastolic is above the supported range', () {
      final result = ClinicalValidator.validateBloodPressure('120', '151');
      expect(result, 'Diastolic value must be between 30 and 150.');
    });

    _groupedTest(bloodPressureProgress, 'Returns error if Diastolic is higher than Systolic (Impossible reading)', () {
      final result = ClinicalValidator.validateBloodPressure('80', '120');
      expect(result, 'Systolic must be higher than Diastolic.');
    });

    _groupedTest(bloodPressureProgress, 'Returns success for a normal blood pressure', () {
      final result = ClinicalValidator.validateBloodPressure('120', '80');
      expect(result, null);
    });
  });

  group('SPO2 and Respiratory Rate Tests', () {
    _groupedTest(spo2AndRespiratoryProgress, 'Returns error if SPO2 is impossibly low', () {
      final result = ClinicalValidator.validateSingleValueTest('SPO2', '20');
      expect(result, 'SPO2 must be between 30% and 100%.');
    });

    _groupedTest(spo2AndRespiratoryProgress, 'Returns error if Respiratory Rate is too high', () {
      final result = ClinicalValidator.validateSingleValueTest('Respiratory Rate', '80');
      expect(result, 'Respiratory rate must be between 5 and 70.');
    });

    _groupedTest(spo2AndRespiratoryProgress, 'Returns error if single-value input is empty', () {
      final result = ClinicalValidator.validateSingleValueTest('SPO2', '   ');
      expect(result, 'Please enter a test value.');
    });

    _groupedTest(spo2AndRespiratoryProgress, 'Returns error if single-value input is not numeric', () {
      final result = ClinicalValidator.validateSingleValueTest('Heart Rate', 'abc');
      expect(result, 'Value must be a valid number.');
    });
  });
}