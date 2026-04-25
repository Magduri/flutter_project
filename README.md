# WeCare - Clinical Record Management System

WeCare is a professional-grade mobile healthcare application built with Flutter and Node.js. Designed for healthcare providers, it allows for the real-time recording, validation, and visualization of patient clinical data. The system features a robust validation engine, interactive trend analysis, and full multi-language support.

## 🚀 Key Features

* **Clinical Vitals Tracking:** Record and monitor Blood Pressure, Heart Rate, Respiratory Rate, and SPO2.
* **Medical Validation Engine:** Prevents impossible or dangerous data entry (e.g., Diastolic higher than Systolic) utilizing a dedicated custom `ClinicalValidator`.
* **Critical Value Alerts:** Immediate "Hard Stop" visual alerts trigger when a patient’s vitals reach predefined emergency thresholds.
* **Interactive Trend Charts:** Visualizes the last 6 clinical records using `fl_chart`, complete with interactive tooltips and a date-stamped X-axis.
* **Full Localization:** Seamlessly supports English and French based on the device's system settings.
* **Automated Testing:** Includes a comprehensive unit test suite to rigorously verify business logic and mathematical boundaries.

## 🛠️ Tech Stack

**Frontend (Mobile App)**
* **Framework:** Flutter (Dart)
* **State Management:** `StatefulWidget` (Local State)
* **Data Visualization:** `fl_chart`

**Backend (REST API)**
* **Environment:** Node.js & Express
* **Database:** MongoDB
* **Data Handling:** Automatic sorting (newest-first) and classification logic

## 📦 Installation & Setup

### 1. Backend Setup
1. Navigate to the backend folder: `cd backend`
2. Install dependencies: `npm install`
3. Configure your MongoDB connection string in your `.env` file.
4. Start the server: `npm start` *(Runs on `http://localhost:3000` by default)*

### 2. Frontend Setup
1. Navigate to the root Flutter directory.
2. Install packages: `flutter pub get`
3. Run the app: `flutter run`

## 🧪 Testing

To ensure the clinical logic is mathematically sound, a suite of unit tests verifies the boundary conditions for all vital signs. 

Run the test suite using the following command:

```bash
flutter test
