import 'package:flutter/material.dart';

class SemesterProgress extends StatelessWidget {
  const SemesterProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        screenWidth * 0.05,
        screenHeight * 0.07,
        screenWidth * 0.05,
        screenHeight * 0.03,
      ),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 148, 151, 244),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Semester Progress",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "week 8 of 16",
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: LinearProgressIndicator(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    value: 0.7,
                    minHeight: 8,
                    backgroundColor: const Color.fromARGB(255, 116, 114, 204),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Text(
            "70% Complete",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
