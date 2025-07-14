import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/employee.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class EmploymentPage extends StatelessWidget {
  final Employee employee;

  const EmploymentPage({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          appBar: AppBar(
            title: const Text('Employment Timeline'),
            backgroundColor: themeProvider.accentColor,
            foregroundColor: Colors.white,
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildEmployeeHeader(themeProvider),
                const SizedBox(height: 24),
                _buildTimelineCard(themeProvider),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmployeeHeader(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeProvider.accentColor,
            themeProvider.accentColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: themeProvider.accentColor.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 26,
              backgroundColor: themeProvider.accentColor.withOpacity(0.1),
              child: Icon(
                Icons.person,
                size: 30,
                color: themeProvider.accentColor,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.fullName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  employee.jobTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    employee.employeeType,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(ThemeProvider themeProvider) {
    return Container(
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
          Text(
            'Employment Timeline',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: themeProvider.accentColor,
            ),
          ),
          const SizedBox(height: 24),
          _buildTimelineProgress(themeProvider),
          const SizedBox(height: 32),
          _buildTimelineDetails(themeProvider),
        ],
      ),
    );
  }

  Widget _buildTimelineProgress(ThemeProvider themeProvider) {
    return Column(
      children: [
        Row(
          children: [
            _buildTimelineDot(true, "Hire Date", themeProvider),
            Expanded(child: _buildTimelineLine(true, themeProvider)),
            _buildTimelineDot(true, "Probation", themeProvider),
            Expanded(child: _buildTimelineLine(employee.terminationDate != null, themeProvider)),
            _buildTimelineDot(employee.terminationDate != null, "Termination", themeProvider),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                DateFormat('MMM dd, yyyy').format(employee.hireDate),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: themeProvider.accentColor,
                ),
              ),
            ),
            Expanded(
              child: Text(
                employee.employeeType,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: themeProvider.accentColor,
                ),
              ),
            ),
            Expanded(
              child: Text(
                employee.terminationDate != null 
                    ? DateFormat('MMM dd, yyyy').format(employee.terminationDate!)
                    : "Active",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: employee.terminationDate != null 
                      ? Colors.red[600]
                      : themeProvider.accentColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimelineDot(bool isActive, String label, ThemeProvider themeProvider) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? themeProvider.accentColor : Colors.grey[300],
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
        boxShadow: [
          if (isActive)
            BoxShadow(
              color: themeProvider.accentColor.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Icon(
        _getTimelineIcon(label),
        size: 16,
        color: isActive ? Colors.white : Colors.grey[500],
      ),
    );
  }

  Widget _buildTimelineLine(bool isActive, ThemeProvider themeProvider) {
    return Container(
      height: 3,
      decoration: BoxDecoration(
        color: isActive ? themeProvider.accentColor : Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  IconData _getTimelineIcon(String label) {
    switch (label) {
      case "Hire Date":
        return Icons.work_outline;
      case "Probation":
        return Icons.schedule;
      case "Termination":
        return Icons.event_busy;
      default:
        return Icons.circle;
    }
  }

  Widget _buildTimelineDetails(ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Timeline Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: themeProvider.accentColor,
          ),
        ),
        const SizedBox(height: 16),
        _buildDetailCard(
          icon: Icons.work,
          title: "Hire Date",
          date: DateFormat('MMMM dd, yyyy').format(employee.hireDate),
          description: "Employee officially joined ${employee.company}",
          themeProvider: themeProvider,
        ),
        const SizedBox(height: 12),
        if (employee.probationNotes7Days != null)
          _buildDetailCard(
            icon: Icons.schedule,
            title: "7 Days Probation Review",
            date: DateFormat('MMMM dd, yyyy').format(employee.hireDate.add(const Duration(days: 7))),
            description: employee.probationNotes7Days!,
            themeProvider: themeProvider,
          ),
        const SizedBox(height: 12),
        if (employee.probationNotes3Months != null)
          _buildDetailCard(
            icon: Icons.assessment,
            title: "3 Months Probation Review",
            date: DateFormat('MMMM dd, yyyy').format(employee.hireDate.add(const Duration(days: 90))),
            description: employee.probationNotes3Months!,
            themeProvider: themeProvider,
          ),
        const SizedBox(height: 12),
        if (employee.probationNotes6Months != null)
          _buildDetailCard(
            icon: Icons.verified,
            title: "6 Months Probation Review",
            date: DateFormat('MMMM dd, yyyy').format(employee.hireDate.add(const Duration(days: 180))),
            description: employee.probationNotes6Months!,
            themeProvider: themeProvider,
          ),
        const SizedBox(height: 12),
        if (employee.terminationDate != null) ...[
          _buildDetailCard(
            icon: Icons.event_busy,
            title: "Termination Date",
            date: DateFormat('MMMM dd, yyyy').format(employee.terminationDate!),
            description: employee.resignationNotes ?? "Employment terminated",
            isTermination: true,
            themeProvider: themeProvider,
          ),
          const SizedBox(height: 12),
        ],
        _buildDetailCard(
          icon: Icons.update,
          title: "Last Updated",
          date: DateFormat('MMMM dd, yyyy - HH:mm').format(employee.lastUpdated),
          description: "Profile information last updated",
          themeProvider: themeProvider,
        ),
      ],
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String date,
    required String description,
    required ThemeProvider themeProvider,
    bool isTermination = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isTermination ? Colors.red[50] : themeProvider.accentColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isTermination ? Colors.red[200]! : themeProvider.accentColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isTermination ? Colors.red[100] : themeProvider.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isTermination ? Colors.red[600] : themeProvider.accentColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isTermination ? Colors.red[800] : themeProvider.accentColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: themeProvider.textColor.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: themeProvider.textColor.withOpacity(0.8),
                    height: 1.4,
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
