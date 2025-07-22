import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/splash_screen.dart';
import 'providers/employee_data_provider.dart';
import 'providers/assignment_provider.dart';
import 'providers/asset_provider.dart';
import 'providers/dependent_provider.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final provider = EmployeeDataProvider();
            // Initialize with sample data first
            provider.initializeWithSampleData();
            // Then check connection and try to load real data
            provider.checkConnection().then((_) {
              if (provider.isOnline) {
                // Try to load a specific employee (using sample ID)
                provider.loadEmployeeById('00000231').catchError((error) {
                  print('🚨 Failed to load employee from API: $error');
                  // Error is already handled in the provider, just log it
                });
              }
            }).catchError((error) {
              print('🚨 Failed to check API connection: $error');
              // Connection check failed, will stay offline
            });
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) => AssignmentProvider()..initializeWithSampleData(),
        ),
        ChangeNotifierProvider(
          create: (_) {
            final provider = AssetProvider();
            // Initialize with sample data first, then try API
            provider.initializeWithSampleData();
            // Try to load from API, fallback to sample data if needed
            provider.loadAssets().catchError((error) {
              print('🚨 Failed to load assets from API: $error');
              // Error is already handled in the provider, just log it
            });
            return provider;
          },
        ),
        ChangeNotifierProvider(create: (_) => DependentProvider()..initializeWithSampleData()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'KMI Profile Mobile',
            theme: themeProvider.themeData,
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

