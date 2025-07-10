import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/splash_screen.dart';
import 'providers/employee_data_provider.dart';
import 'providers/assignment_provider.dart';
import 'providers/asset_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EmployeeDataProvider()),
        ChangeNotifierProvider(create: (_) => AssignmentProvider()..initializeWithSampleData()),
        ChangeNotifierProvider(create: (_) => AssetProvider()..initializeWithSampleData()),
      ],
      child: MaterialApp(
        title: 'KMI Profile Mobile',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2A9D01)),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

