import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/employee.dart';
import '../models/api_response.dart';
import '../config/api_config.dart';

class ApiService {
  /// Get all employees
  static Future<List<Employee>> getEmployees() async {
    try {
      // From your Swagger, the employees endpoint has parameters like isActive, etc.
      // Let's start with basic query to get active employees
      final url = '${ApiConfig.baseUrl}${ApiConfig.employeesEndpoint}?isActive=true';
      print('🔍 Fetching employees from: $url');
      
      final response = await http
          .get(
            Uri.parse(url),
            headers: ApiConfig.defaultHeaders,
          )
          .timeout(ApiConfig.requestTimeout);

      print('📡 Employees API Response: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('📊 Raw API Response: ${jsonResponse.toString().substring(0, 200)}...');
        
        List<dynamic> employeesList = [];
        
        // Handle the nested response structure: response.result.content[]
        if (jsonResponse is Map && jsonResponse['result'] != null) {
          final result = jsonResponse['result'];
          if (result is Map && result['content'] != null && result['content'] is List) {
            employeesList = result['content'];
            print('✅ Successfully parsed ${employeesList.length} employees from result.content');
          } else {
            print('❌ Result.content is not a list: ${result['content']}');
            return []; // Return empty list instead of throwing error
          }
        } else {
          print('❌ Response structure unexpected');
          return []; // Return empty list instead of throwing error
        }
        
        if (employeesList.isEmpty) {
          print('⚠️ No employees found in response');
          return [];
        }
        
        // Convert to Employee objects
        final employees = employeesList.map((json) {
          try {
            return Employee.fromJson(json);
          } catch (e) {
            print('⚠️ Failed to parse employee: $json, error: $e');
            return null;
          }
        }).where((emp) => emp != null).cast<Employee>().toList();
        
        print('✅ Successfully converted ${employees.length} employees');
        return employees;
        
      } else if (response.statusCode == 401) {
        print('🔐 API requires authentication (401)');
        return []; // Return empty instead of throwing
      } else if (response.statusCode == 403) {
        print('🚫 API access forbidden (403)');
        return []; // Return empty instead of throwing
      } else if (response.statusCode == 404) {
        print('❌ Employees endpoint not found (404)');
        return []; // Return empty instead of throwing
      } else {
        print('❌ API returned: ${response.statusCode}');
        return []; // Return empty instead of throwing
      }
    } catch (e) {
      print('💥 Employee API error: $e');
      return []; // Always return empty list instead of throwing to prevent crashes
    }
  }

  /// Get employee by ID
  static Future<Employee> getEmployeeById(String employeeId) async {
    try {
      // From your Swagger, it looks like we might need to use the search endpoint
      // Let's try the employees endpoint with employeeId parameter
      final url = '${ApiConfig.baseUrl}${ApiConfig.employeesEndpoint}?employeeId=$employeeId';
      print('🔍 Fetching employee by ID from: $url');
      
      final response = await http
          .get(
            Uri.parse(url),
            headers: ApiConfig.defaultHeaders,
          )
          .timeout(ApiConfig.requestTimeout);

      print('📡 Employee by ID API Response: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('📊 Employee API Response structure: ${jsonResponse.keys}');
        
        // Check if response has the expected wrapper structure
        if (jsonResponse.containsKey('content') && jsonResponse['content'] is List) {
          final List<dynamic> contentList = jsonResponse['content'];
          if (contentList.isNotEmpty) {
            return Employee.fromJson(contentList.first);
          } else {
            throw ApiException('Employee not found');
          }
        } else if (jsonResponse.containsKey('content')) {
          return Employee.fromJson(jsonResponse['content']);
        } else {
          // Fallback: try to parse as direct object
          return Employee.fromJson(jsonResponse);
        }
      } else if (response.statusCode == 404) {
        throw ApiException('Employee not found');
      } else if (response.statusCode == 401) {
        throw ApiException('Authentication required (401)');
      } else if (response.statusCode == 403) {
        throw ApiException('Access forbidden (403)');
      } else {
        throw ApiException('Failed to load employee: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Employee by ID API error: $e');
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
      // Try the employees endpoint instead of health since health doesn't exist
      final testUrl = '${ApiConfig.baseUrl}${ApiConfig.employeesEndpoint}';
      print('🔍 Testing API connection to: $testUrl');
      
      final response = await http
          .get(
            Uri.parse(testUrl),
            headers: ApiConfig.defaultHeaders,
          )
          .timeout(const Duration(seconds: 10));

      print('📡 API Response: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        print('✅ API Connection successful');
        return true;
      } else if (response.statusCode == 401) {
        print('🔐 API requires authentication (401)');
        return false;
      } else if (response.statusCode == 403) {
        print('🚫 API access forbidden (403)');
        return false;
      } else if (response.statusCode == 404) {
        print('❌ API endpoint not found (404)');
        return false;
      } else {
        print('❌ API returned: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('💥 API Connection error: $e');
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
