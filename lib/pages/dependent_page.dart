import 'package:flutter/material.dart';

class DependentPage extends StatelessWidget {
  const DependentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dependents'),
        backgroundColor: const Color(0xFF2A9D01),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.family_restroom,
              size: 80,
              color: Color(0xFF2A9D01),
            ),
            SizedBox(height: 20),
            Text(
              'Dependent Page',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2A9D01),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Employee dependents will be displayed here',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
