import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/scheduler.dart';
import '../models/employee.dart';
import '../services/api_service.dart';

class EmployeeDataProvider extends ChangeNotifier {
  Employee? _currentEmployee;
  List<Employee> _employees = [];
  bool _isLoading = false;
  String? _error;
  bool _isOnline = false;

  // Getters
  Employee? get currentEmployee => _currentEmployee;
  List<Employee> get employees => _employees;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isOnline => _isOnline;

  /// Safe notification method to avoid calling during build
  void _safeNotify() {
    if (WidgetsBinding.instance.schedulerPhase != SchedulerPhase.persistentCallbacks) {
      notifyListeners();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    _safeNotify();
  }

  /// Set error state
  void _setError(String? error) {
    _error = error;
    _safeNotify();
  }

  /// Clear error
  void clearError() {
    _error = null;
    _safeNotify();
  }

  /// Check if API is available
  Future<void> checkConnection() async {
    try {
      _isOnline = await ApiService.checkConnection();
      _safeNotify();
    } catch (e) {
      _isOnline = false;
      _safeNotify();
    }
  }

  /// Load employee by ID
  Future<void> loadEmployeeById(String employeeId) async {
    _setLoading(true);
    _setError(null);

    try {
      // Check connection first
      await checkConnection();
      
      if (_isOnline) {
        // Try to fetch from API
        _currentEmployee = await ApiService.getEmployeeById(employeeId);
      } else {
        // Fall back to sample data
        _currentEmployee = Employee.sample();
        _setError('Using offline data - API not available');
      }
    } catch (e) {
      _setError('Failed to load employee: $e');
      // Fallback to sample data
      _currentEmployee = Employee.sample();
    } finally {
      _setLoading(false);
    }
  }

  /// Load employee by username
  Future<void> loadEmployeeByUsername(String username) async {
    _setLoading(true);
    _setError(null);

    try {
      await checkConnection();
      
      if (_isOnline) {
        _currentEmployee = await ApiService.getEmployeeByUsername(username);
      } else {
        _currentEmployee = Employee.sample();
        _setError('Using offline data - API not available');
      }
    } catch (e) {
      _setError('Failed to load employee: $e');
      _currentEmployee = Employee.sample();
    } finally {
      _setLoading(false);
    }
  }

  /// Load all employees
  Future<void> loadAllEmployees() async {
    _setLoading(true);
    _setError(null);

    try {
      await checkConnection();
      
      if (_isOnline) {
        _employees = await ApiService.getEmployees();
      } else {
        _employees = [Employee.sample()];
        _setError('Using offline data - API not available');
      }
    } catch (e) {
      _setError('Failed to load employees: $e');
      _employees = [Employee.sample()];
    } finally {
      _setLoading(false);
    }
  }

  /// Search employees
  Future<void> searchEmployees(String query) async {
    _setLoading(true);
    _setError(null);

    try {
      await checkConnection();
      
      if (_isOnline) {
        _employees = await ApiService.searchEmployees(query);
      } else {
        // Simple local search fallback
        _employees = [Employee.sample()].where((emp) =>
          emp.fullName.toLowerCase().contains(query.toLowerCase()) ||
          emp.employeeId.toLowerCase().contains(query.toLowerCase())
        ).toList();
        _setError('Using offline search - API not available');
      }
    } catch (e) {
      _setError('Failed to search employees: $e');
      _employees = [];
    } finally {
      _setLoading(false);
    }
  }

  /// Update employee data
  Future<void> updateEmployee(Employee employee) async {
    _setLoading(true);
    _setError(null);

    try {
      await checkConnection();
      
      if (_isOnline) {
        _currentEmployee = await ApiService.updateEmployee(employee);
      } else {
        _setError('Cannot update - API not available');
      }
    } catch (e) {
      _setError('Failed to update employee: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Initialize with sample data (for offline mode or fallback)
  void initializeWithSampleData() {
    _currentEmployee = Employee.sample();
    _employees = [Employee.sample()];
    _safeNotify();
  }

  /// Reset all data
  void reset() {
    _currentEmployee = null;
    _employees = [];
    _isLoading = false;
    _error = null;
    _isOnline = false;
    _safeNotify();
  }
}
