import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/employee.dart';
import '../config/api_config.dart';

class ApiService {
  /// Get all employees
  static Future<List<Employee>> getEmployees() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.employeesEndpoint}'),
            headers: ApiConfig.defaultHeaders,
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Employee.fromJson(json)).toList();
      } else {
        throw ApiException('Failed to load employees: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  /// Get employee by ID
  static Future<Employee> getEmployeeById(String employeeId) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.employeeByIdEndpoint(employeeId)}'),
            headers: ApiConfig.defaultHeaders,
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Employee.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        throw ApiException('Employee not found');
      } else {
        throw ApiException('Failed to load employee: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  /// Get employee by username (if your API supports this)
  static Future<Employee> getEmployeeByUsername(String username) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.employeeByUsernameEndpoint(username)}'),
            headers: ApiConfig.defaultHeaders,
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Employee.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        throw ApiException('Employee not found');
      } else {
        throw ApiException('Failed to load employee: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  /// Search employees by name or other criteria
  static Future<List<Employee>> searchEmployees(String query) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.searchEmployeesEndpoint(query)}'),
            headers: ApiConfig.defaultHeaders,
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Employee.fromJson(json)).toList();
      } else {
        throw ApiException('Failed to search employees: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  /// Update employee data (if your API supports this)
  static Future<Employee> updateEmployee(Employee employee) async {
    try {
      final response = await http
          .put(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.employeeByIdEndpoint(employee.employeeId)}'),
            headers: ApiConfig.defaultHeaders,
            body: json.encode(employee.toJson()),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Employee.fromJson(jsonData);
      } else {
        throw ApiException('Failed to update employee: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  /// Check API health/connection
  static Future<bool> checkConnection() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.healthEndpoint}'),
            headers: ApiConfig.defaultHeaders,
          )
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

/// Custom exception class for API errors
class ApiException implements Exception {
  final String message;
  
  ApiException(this.message);
  
  @override
  String toString() => 'ApiException: $message';
}
