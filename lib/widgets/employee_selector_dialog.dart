import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../services/api_service.dart';

class EmployeeSelectorDialog extends StatefulWidget {
  final Function(Employee) onEmployeeSelected;

  const EmployeeSelectorDialog({
    super.key,
    required this.onEmployeeSelected,
  });

  @override
  State<EmployeeSelectorDialog> createState() => _EmployeeSelectorDialogState();
}

class _EmployeeSelectorDialogState extends State<EmployeeSelectorDialog> {
  List<Employee> employees = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final loadedEmployees = await ApiService.getEmployees().timeout(
        const Duration(seconds: 10), // 10 second timeout
        onTimeout: () {
          print('⏰ Employee loading timed out');
          return <Employee>[]; // Return empty list on timeout
        },
      );
      
      setState(() {
        employees = loadedEmployees;
        isLoading = false;
        if (employees.isEmpty) {
          errorMessage = 'No employees found or API unavailable';
        }
      });
    } catch (e) {
      print('💥 Employee selector error: $e');
      setState(() {
        errorMessage = 'Failed to load employees: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Employee',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(),
            
            // Content
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading employees...'),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadEmployees,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (employees.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No employees found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: employees.length,
      itemBuilder: (context, index) {
        final employee = employees[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Text(
                employee.fullName.isNotEmpty 
                    ? employee.fullName[0].toUpperCase()
                    : 'E',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            title: Text(
              employee.fullName,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${employee.employeeId}'),
                Text('${employee.jobTitle} • ${employee.department}'),
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  child: Chip(
                    label: Text(
                      employee.employeeStatus,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: employee.employeeStatus.toLowerCase() == 'active'
                        ? Colors.green[100]
                        : Colors.orange[100],
                    side: BorderSide(
                      color: employee.employeeStatus.toLowerCase() == 'active'
                          ? Colors.green
                          : Colors.orange,
                      width: 1,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              widget.onEmployeeSelected(employee);
              Navigator.of(context).pop();
            },
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        );
      },
    );
  }
}
