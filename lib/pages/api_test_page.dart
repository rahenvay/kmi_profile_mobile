import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/employee_data_provider.dart';
import '../providers/asset_provider.dart';
import '../services/api_service.dart';

class ApiTestPage extends StatefulWidget {
  const ApiTestPage({super.key});

  @override
  State<ApiTestPage> createState() => _ApiTestPageState();
}

class _ApiTestPageState extends State<ApiTestPage> {
  String _apiStatus = 'Not tested';
  String _employeeStatus = 'Not tested';
  String _assetStatus = 'Not tested';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Integration Test'),
        backgroundColor: const Color(0xFF2A9D01),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'API Integration Status',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // API Connection Test
            Card(
              child: ListTile(
                leading: Icon(
                  _apiStatus.contains('Connected') ? Icons.check_circle : Icons.error,
                  color: _apiStatus.contains('Connected') ? Colors.green : Colors.red,
                ),
                title: const Text('API Connection'),
                subtitle: Text(_apiStatus),
                trailing: ElevatedButton(
                  onPressed: _isLoading ? null : _testApiConnection,
                  child: const Text('Test'),
                ),
              ),
            ),

            // Employee Data Test
            Card(
              child: ListTile(
                leading: Icon(
                  _employeeStatus.contains('Success') ? Icons.check_circle : Icons.error,
                  color: _employeeStatus.contains('Success') ? Colors.green : Colors.red,
                ),
                title: const Text('Employee Data'),
                subtitle: Text(_employeeStatus),
                trailing: ElevatedButton(
                  onPressed: _isLoading ? null : _testEmployeeData,
                  child: const Text('Test'),
                ),
              ),
            ),

            // Asset Data Test
            Card(
              child: ListTile(
                leading: Icon(
                  _assetStatus.contains('Success') ? Icons.check_circle : Icons.error,
                  color: _assetStatus.contains('Success') ? Colors.green : Colors.red,
                ),
                title: const Text('Asset Data'),
                subtitle: Text(_assetStatus),
                trailing: ElevatedButton(
                  onPressed: _isLoading ? null : _testAssetData,
                  child: const Text('Test'),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Test All Button
            ElevatedButton(
              onPressed: _isLoading ? null : _testAll,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2A9D01),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Test All APIs',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
            ),

            const SizedBox(height: 20),

            // Current Data Display
            Expanded(
              child: Consumer2<EmployeeDataProvider, AssetProvider>(
                builder: (context, employeeProvider, assetProvider, child) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current Data:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),

                        // Employee Data
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Employee: ${employeeProvider.currentEmployee?.fullName ?? 'None'}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('ID: ${employeeProvider.currentEmployee?.employeeId ?? 'None'}'),
                                Text('Status: ${employeeProvider.currentEmployee?.employeeStatus ?? 'None'}'),
                                if (employeeProvider.isLoading)
                                  const LinearProgressIndicator(),
                                if (employeeProvider.error != null)
                                  Text(
                                    'Error: ${employeeProvider.error}',
                                    style: const TextStyle(color: Colors.red),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        // Asset Data
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Assets (${assetProvider.assets.length}):',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                ...assetProvider.assets.take(3).map(
                                      (asset) => Text('• ${asset.type}: ${asset.assetId}'),
                                    ),
                                if (assetProvider.assets.length > 3)
                                  Text('... and ${assetProvider.assets.length - 3} more'),
                                if (assetProvider.isLoading)
                                  const LinearProgressIndicator(),
                                if (assetProvider.error != null)
                                  Text(
                                    'Error: ${assetProvider.error}',
                                    style: const TextStyle(color: Colors.red),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testApiConnection() async {
    setState(() {
      _isLoading = true;
      _apiStatus = 'Testing...';
    });

    try {
      final isConnected = await ApiService.checkConnection();
      setState(() {
        _apiStatus = isConnected ? 'Connected ✓' : 'Connection failed ✗';
      });
    } catch (e) {
      setState(() {
        _apiStatus = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testEmployeeData() async {
    setState(() {
      _isLoading = true;
      _employeeStatus = 'Testing...';
    });

    try {
      final employeeProvider = Provider.of<EmployeeDataProvider>(context, listen: false);
      await employeeProvider.loadEmployeeById('00000228'); // Using sample employee ID
      
      setState(() {
        _employeeStatus = employeeProvider.currentEmployee != null 
            ? 'Success: Employee loaded ✓' 
            : 'Failed to load employee ✗';
      });
    } catch (e) {
      setState(() {
        _employeeStatus = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testAssetData() async {
    setState(() {
      _isLoading = true;
      _assetStatus = 'Testing...';
    });

    try {
      final assetProvider = Provider.of<AssetProvider>(context, listen: false);
      await assetProvider.loadAssets();
      
      setState(() {
        _assetStatus = assetProvider.assets.isNotEmpty 
            ? 'Success: ${assetProvider.assets.length} assets loaded ✓' 
            : 'No assets found ✗';
      });
    } catch (e) {
      setState(() {
        _assetStatus = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testAll() async {
    await _testApiConnection();
    await Future.delayed(const Duration(milliseconds: 500));
    await _testEmployeeData();
    await Future.delayed(const Duration(milliseconds: 500));
    await _testAssetData();
  }
}
