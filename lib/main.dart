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
        ChangeNotifierProvider(create: (_) => EmployeeDataProvider()),
        ChangeNotifierProvider(create: (_) => AssignmentProvider()..initializeWithSampleData()),
        ChangeNotifierProvider(create: (_) => AssetProvider()..initializeWithSampleData()),
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

