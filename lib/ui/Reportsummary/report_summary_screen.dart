import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportSummaryScreen extends StatefulWidget {
  const ReportSummaryScreen({super.key});

  @override
  _ReportSummaryScreenState createState() => _ReportSummaryScreenState();
}

class _ReportSummaryScreenState extends State<ReportSummaryScreen> {
  final TextEditingController presentController = TextEditingController();
  final TextEditingController absentController = TextEditingController();
  final TextEditingController permissionController = TextEditingController();
  final TextEditingController lateController = TextEditingController();
  final TextEditingController sickController = TextEditingController();
  final TextEditingController onLeaveController = TextEditingController();
  final TextEditingController overtimeController = TextEditingController();

  void saveReport() async {
    try {
      await FirebaseFirestore.instance
          .collection('attendance')
          .doc('raport_id')
          .set({
        'present': presentController.text,
        'absent': absentController.text,
        'permission': permissionController.text,
        'late': lateController.text,
        'sick': sickController.text,
        'onLeave': onLeaveController.text,
        'overtime': overtimeController.text,
      });
      showSnackbar("Report successfully saved!", Colors.green);
    } catch (e) {
      showSnackbar("Failed to save report: $e", Colors.red);
    }
  }

  void showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  InputField(
                      controller: presentController,
                      label: "Total Present",
                      icon: Icons.check_circle),
                  InputField(
                      controller: absentController,
                      label: "Total Absent",
                      icon: Icons.cancel),
                  InputField(
                      controller: permissionController,
                      label: "Total Permission",
                      icon: Icons.assignment),
                  InputField(
                      controller: lateController,
                      label: "Total Late",
                      icon: Icons.access_time),
                  InputField(
                      controller: sickController,
                      label: "Total Sick",
                      icon: Icons.healing),
                  InputField(
                      controller: onLeaveController,
                      label: "Total On Leave",
                      icon: Icons.airplane_ticket),
                  InputField(
                      controller: overtimeController,
                      label: "Total Overtime",
                      icon: Icons.more_time),
                ],
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
                onPressed: saveReport,
                child: const Text("Save Report",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const InputField(
      {super.key,
      required this.controller,
      required this.label,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.blueAccent.withOpacity(0.1),
        ),
      ),
    );
  }
}
