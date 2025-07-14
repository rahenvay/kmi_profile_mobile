import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/employee.dart';
import '../providers/theme_provider.dart';

class EmergencyPage extends StatelessWidget {
  final Employee employee;

  const EmergencyPage({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildEmergencyHeader(),
            const SizedBox(height: 24),
            _buildEmergencyContactCard(themeProvider),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
      }
    );
  }

  Widget _buildEmergencyHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.red.shade600,
            Colors.red.shade700,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.emergency,
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          const Text(
            'Emergency Contact',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'In case of emergency, contact the person below',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactCard(ThemeProvider themeProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeProvider.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.contact_emergency,
                  color: Colors.red.shade600,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Emergency Contact',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2A9D01),
                        
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Primary contact person',
                      style: TextStyle(
                        fontSize: 14,
                        color: themeProvider.textColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (employee.emergencyContactName != null) ...[
            _buildContactInfo(
              Icons.person,
              'Full Name',
              employee.emergencyContactName!,
              Colors.blue,
            ),
            const SizedBox(height: 16),
          ],
          if (employee.emergencyContactRelationship != null) ...[
            _buildContactInfo(
              Icons.family_restroom,
              'Relationship',
              employee.emergencyContactRelationship!,
              Colors.green,
            ),
            const SizedBox(height: 16),
          ],
          if (employee.emergencyContactPhone != null) ...[
            _buildContactInfo(
              Icons.phone,
              'Phone Number',
              employee.emergencyContactPhone!,
              Colors.orange,
            ),
            const SizedBox(height: 16),
          ],
          if (employee.emergencyContactEmail != null) ...[
            _buildContactInfo(
              Icons.email,
              'Email Address',
              employee.emergencyContactEmail!,
              Colors.purple,
            ),
          ],
          if (employee.emergencyContactName == null &&
              employee.emergencyContactPhone == null &&
              employee.emergencyContactEmail == null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 239, 238, 238),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 40,
                    color: themeProvider.textColor,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No Emergency Contact',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Emergency contact information not available',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
