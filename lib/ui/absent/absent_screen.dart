import 'package:flutter/material.dart';

class page1Screen extends StatelessWidget {
  const page1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          SizedBox(
            height: 50,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blueAccent,
                iconTheme: const IconThemeData(color: Colors.white),
                centerTitle: true,
                title: const Text(
                  "Attendance - Flutter App Admin",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Text('Absent Screen View'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}