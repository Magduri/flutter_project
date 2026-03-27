import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/network_manager.dart';
import 'add_clinical_record_screen.dart';
import 'package:intl/intl.dart';

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

  Future<void> fetchRecords() async {
    try {
      final data = await NetworkManager.instance.getPatientRecords(widget.patientId);
      if (mounted) {
        setState(() {
          _records = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  //DUAL-LINE CHART LOGIC ---
  void _showTrendChart(BuildContext context, String testType) {
    List<LineChartBarData> lineBars = [];

   
    final allTypeRecords = _records.where((r) => r['type'] == testType).toList();
    final filteredRecords = allTypeRecords.take(6).toList().reversed.toList();


    // 1. IF IT IS BLOOD PRESSURE (Draw Two Lines)
    if (testType.toLowerCase() == 'blood pressure') {
      List<FlSpot> sysSpots = [];
      List<FlSpot> diaSpots = [];

      for (int i = 0; i < filteredRecords.length; i++) {
        final record = filteredRecords[i];
        if (record['systolic'] != null && record['diastolic'] != null) {
          sysSpots.add(FlSpot(i.toDouble(), (record['systolic'] as num).toDouble()));
          diaSpots.add(FlSpot(i.toDouble(), (record['diastolic'] as num).toDouble()));
        }
      }

      lineBars = [
        LineChartBarData(
          spots: sysSpots,
          isCurved: true,
          color: Colors.redAccent, // Systolic is Red
          barWidth: 4,
          dotData: const FlDotData(show: true),
        ),
        LineChartBarData(
          spots: diaSpots,
          isCurved: true,
          color: Colors.blueAccent, // Diastolic is Blue
          barWidth: 4,
          dotData: const FlDotData(show: true),
        ),
      ];
    } 
    // 2. IF IT IS ANYTHING ELSE (Draw One Line)
    else {
      List<FlSpot> spots = [];
      for (int i = 0; i < filteredRecords.length; i++) {
        final record = filteredRecords[i];
        final val = double.tryParse(record['value'].toString());
        if (val != null) {
          spots.add(FlSpot(i.toDouble(), val));
        }
      }

      lineBars = [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: const Color(0xFFE53935),
          barWidth: 4,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(show: true, color: const Color(0xFFE53935).withOpacity(0.15)),
        ),
      ];
    }

    //THE BOTTOM SHEET UI with the Chart
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$testType Trend', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
              
             
              if (testType.toLowerCase() == 'blood pressure')
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.circle, color: Colors.redAccent, size: 12),
                      SizedBox(width: 4),
                      Text('Systolic', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      SizedBox(width: 16),
                      Icon(Icons.circle, color: Colors.blueAccent, size: 12),
                      SizedBox(width: 4),
                      Text('Diastolic', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              const SizedBox(height: 30),

              // The Chart
              if (lineBars.isEmpty || lineBars.first.spots.length < 2)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Center(child: Text("We need at least 2 records to show a trend.", style: TextStyle(color: Colors.grey, fontSize: 16))),
                )
              else
                SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: true, drawVerticalLine: false), 
                      titlesData: FlTitlesData(
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (value == index.toDouble() && index >= 0 && index < filteredRecords.length) {
                                final dateStr = filteredRecords[index]['measuredDateTime'] ?? '';
                                if (dateStr.isNotEmpty) {
                                  try {
                                    final date = DateFormat('MMM dd').format(DateTime.parse(dateStr).toLocal());
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(date, style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
                                    );
                                  } catch (e) {
                                    return const Text('');
                                  }
                                }
                              }
                              return const Text('');
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),

                       lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (touchedSpot) => const Color(0xFF263238),
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((LineBarSpot touchedSpot) {
                              
                              // 1. Get the date from our filtered records
                              final index = touchedSpot.x.toInt();
                              final record = filteredRecords[index];
                              final dateStr = record['measuredDateTime'] ?? '';
                              
                              String formattedDate = 'Unknown Date';
                              if (dateStr.isNotEmpty) {
                                try {
                                  // Formats into "Mar 27"
                                  formattedDate = DateFormat('MMM dd').format(DateTime.parse(dateStr).toLocal());
                                } catch (e) {
                                  // Fallback if parsing fails
                                }
                              }

                              // 2. Format the tooltip based on the chart type
                              if (testType.toLowerCase() == 'blood pressure') {
                                if (touchedSpot.barIndex == 0) {
                                  return LineTooltipItem(
                                    '$formattedDate\nSys: ${touchedSpot.y.toInt()}',
                                    const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                                  );
                                } else {
                                  return LineTooltipItem(
                                    '$formattedDate\nDia: ${touchedSpot.y.toInt()}',
                                    const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                                  );
                                }
                              } else {
                                return LineTooltipItem(
                                  '$formattedDate\nValue: ${touchedSpot.y}',
                                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                );
                              }
                            }).toList();
                          },
                        ),
                      ),

                      lineBarsData: lineBars, 
                    ),
                  ),
                ),
              
              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Close Chart', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text('${widget.patientName} - Records', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF00796B),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
       
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF00796B)))
                : _records.isEmpty
                    ? const Center(child: Text("No clinical records found.\nAdd a new test to get started.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16)))
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
                                child: Icon(Icons.show_chart, color: isCritical ? Colors.redAccent : const Color(0xFF00796B)),
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
                              onTap: () => _showTrendChart(context, testType),
                            ),
                          );
                        },
                      ),
          ),
          
          Container(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00796B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Add New Test Record', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddClinicalRecordScreen(patientId: widget.patientId)),
                  );
                  if (result == true) {
                    setState(() => _isLoading = true);
                    fetchRecords();
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}