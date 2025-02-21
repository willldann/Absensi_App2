import 'package:absensi_app/ui/Reportsummary/report_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportViewScreen extends StatefulWidget {
  const ReportViewScreen({super.key});

  @override
  _ReportViewScreenState createState() => _ReportViewScreenState();
}

class _ReportViewScreenState extends State<ReportViewScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> fetchReport() async {
    try {
      DocumentSnapshot doc = await _firestore.collection('attendance').doc('raport_id').get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint("Error fetching report: $e");
    }
    return null;
  }

  void deleteReport() async {
    try {
      await _firestore.collection('attendance').doc('raport_id').delete();
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Report deleted successfully"), backgroundColor: Colors.red),
      );
    } catch (e) {
      debugPrint("Error deleting report: $e");
    }
  }

  void updateReport(String key, dynamic newValue) async {
    try {
      await _firestore.collection('attendance').doc('raport_id').update({key: newValue});
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Report updated successfully"), backgroundColor: Colors.green),
      );
    } catch (e) {
      debugPrint("Error updating report: $e");
    }
  }

  void addReportField() async {
    try {
      await _firestore.collection('attendance').doc('raport_id').set({'New Field': 'New Value'}, SetOptions(merge: true));
      setState(() {});
    } catch (e) {
      debugPrint("Error adding field: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Report Summary",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: addReportField,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: deleteReport,
          )
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?> (
        future: fetchReport(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No report data available"));
          }

          Map<String, dynamic> data = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: data.entries.map((entry) {
                      return ReportCard(
                        title: entry.key,
                        value: entry.value,
                        onEdit: (newValue) => updateReport(entry.key, newValue),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ReportSummaryScreen()),
                      ).then((_) => setState(() {}));
                    },
                    child: const Text("Edit Report", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final String title;
  final dynamic value;
  final Function(String) onEdit;

  const ReportCard({super.key, required this.title, required this.value, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          title.replaceAll(RegExp(r'([a-z])([A-Z])'), r'$1 $2'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.blueAccent),
          onPressed: () async {
            TextEditingController controller = TextEditingController(text: value.toString());
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Edit $title"),
                content: TextField(controller: controller),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      onEdit(controller.text);
                      Navigator.pop(context);
                    },
                    child: const Text("Save"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
