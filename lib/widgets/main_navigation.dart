import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/employee_data_provider.dart';
import '../providers/theme_provider.dart';
import '../pages/enhanced_profile_page.dart';
import '../pages/employment_page.dart';
import '../pages/assignment_page.dart';
import '../pages/asset_page.dart';
import '../pages/emergency_page.dart';
import '../pages/dependent_page.dart';


class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeDataProvider>(
      builder: (context, dataProvider, child) {
        // If data is still loading, show loading indicator
        if (dataProvider.isLoading) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF2A9D01),
                    const Color(0xFF228701),
                  ],
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 20),
                    Text(
                      'Loading employee data...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // If there's an error and no employee data, show error
        if (dataProvider.currentEmployee == null) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF2A9D01),
                    const Color(0xFF228701),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white, size: 60),
                    const SizedBox(height: 20),
                    Text(
                      'Failed to load employee data',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    if (dataProvider.error != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        dataProvider.error!,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        dataProvider.loadEmployeeById('00000228');
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final employee = dataProvider.currentEmployee!;
        final pages = [
          EnhancedProfilePage(employee: employee),
          EmploymentPage(employee: employee),
          const AssignmentPage(),
          const AssetPage(),
          EmergencyPage(employee: employee),
          const DependentPage(),
        
        ];

        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'KMI Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: themeProvider.accentColor,
                elevation: 0,
                actions: [
                  // Theme toggle button
                  IconButton(
                    onPressed: () {
                      themeProvider.toggleTheme();
                    },
                    icon: Icon(
                      themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      color: Colors.white,
                    ),
                    tooltip: themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
                  ),
                  // API Status indicator
                  if (dataProvider.error != null)
                    IconButton(
                      onPressed: () {
                        _showApiStatusDialog(context, dataProvider);
                      },
                      icon: Icon(
                        dataProvider.isOnline ? Icons.cloud_done : Icons.cloud_off,
                        color: dataProvider.isOnline ? Colors.white : Colors.orange,
                      ),
                      tooltip: dataProvider.isOnline ? 'Online' : 'Offline',
                    ),
                  // Refresh button
                  IconButton(
                    onPressed: () {
                      dataProvider.loadEmployeeById(employee.employeeId);
                    },
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    tooltip: 'Refresh Data',
                  ),
                ],
              ),
          body: IndexedStack(
            index: _selectedIndex,
            children: pages,
          ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: const Color(0xFF2A9D01),
          unselectedItemColor: Colors.grey[600],
          backgroundColor: Colors.white,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Icon(Icons.person_outline, size: 24),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Icon(Icons.person, size: 26),
              ),
              label: 'General',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Icon(Icons.work_outline, size: 24),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Icon(Icons.work, size: 26),
              ),
              label: 'Employment',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Icon(Icons.assignment_outlined, size: 24),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Icon(Icons.assignment, size: 26),
              ),
              label: 'Assignment',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Icon(Icons.inventory_2_outlined, size: 24),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Icon(Icons.inventory_2, size: 26),
              ),
              label: 'Assets',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Icon(Icons.emergency_outlined, size: 24),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Icon(Icons.emergency, size: 26),
              ),
              label: 'Emergency',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Icon(Icons.people_outline, size: 24),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Icon(Icons.people, size: 26),
              ),
              label: 'Dependents',
            ),
          ],
        ),
      ),
            );
          },
        );
      },
    );
  }

  void _showApiStatusDialog(BuildContext context, EmployeeDataProvider dataProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              dataProvider.isOnline ? Icons.cloud_done : Icons.cloud_off,
              color: dataProvider.isOnline ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 10),
            Text(dataProvider.isOnline ? 'Online' : 'Offline'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dataProvider.isOnline 
                ? 'Connected to API server'
                : 'Using offline data',
            ),
            if (dataProvider.error != null) ...[
              const SizedBox(height: 10),
              Text(
                'Error: ${dataProvider.error}',
                style: TextStyle(color: Colors.red[700]),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (!dataProvider.isOnline)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                dataProvider.checkConnection();
              },
              child: const Text('Retry Connection'),
            ),
        ],
      ),
    );
  }
}
