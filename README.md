## WeCare - Clinical Record Management System

WeCare is a professional-grade healthcare application built with Flutter and Node.js. It allows healthcare providers to record, validate, and visualize patient clinical data (vitals) in real-time. The system features a robust validation engine, interactive trend analysis, and full multi-language support.

## 🚀 Key Features

1. Clinical Vitals Tracking: Record Blood Pressure, Heart Rate, Respiratory Rate, and SPO2.
2. Medical Validation Engine: Prevents impossible or dangerous data entry (e.g., Diastolic higher than Systolic) using a dedicated ClinicalValidator.
3. Critical Value Alerts: Immediate "Hard Stop" visual alerts when a patient’s vitals reach emergency thresholds.
4. Interactive Trend Charts: Visualizes the last 6 records using fl_chart with interactive tooltips and a date-stamped X-axis.
5. Full Localization: Supports English and French based on system settings.
6. Automated Testing: Includes a comprehensive Unit Test suite for business logic verification.

## 🛠️ Tech Stack

### Frontend
Framework: Flutter (Dart)

State Management: StatefulWidget (Local State)

Charts: fl_chart

### Backend
Environment: Node.js & Express

Database: MongoDB

Data Handling: Automatic sorting (Newest-first) and classification logic.

## 📦 Installation & Setup
### 1. Backend Setup

Navigate to the /backend folder.

Install dependencies: npm install

Ensure your MongoDB connection string is configured in your .env or config file.

Start the server: npm start (Runs on http://localhost:3000 by default).

### 2. Frontend Setup

Navigate to the root directory.

Install Flutter packages: flutter pub get

Run the app: flutter run

## 🧪 Testing
To ensure the clinical logic is mathematically sound, a suite of unit tests has been implemented. These tests verify the boundary conditions for all vital signs.

To run the tests, execute the following command in your terminal:

```Bash
flutter test
```

Tested Scenarios:

Valid/Invalid Heart Rate boundaries (20–300 bpm).

Blood Pressure logic (Systolic must be $> $ Diastolic).

SPO2 and Respiratory Rate threshold validations.
