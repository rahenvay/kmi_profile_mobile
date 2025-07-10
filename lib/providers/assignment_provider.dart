import 'package:flutter/foundation.dart';

class Project {
  final String id;
  String name;
  String status;
  double progress;
  String deadline;
  String role;
  String priority;
  DateTime createdAt;
  DateTime updatedAt;

  Project({
    required this.id,
    required this.name,
    required this.status,
    required this.progress,
    required this.deadline,
    required this.role,
    required this.priority,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Project copyWith({
    String? name,
    String? status,
    double? progress,
    String? deadline,
    String? role,
    String? priority,
  }) {
    return Project(
      id: id,
      name: name ?? this.name,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      deadline: deadline ?? this.deadline,
      role: role ?? this.role,
      priority: priority ?? this.priority,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'progress': progress,
      'deadline': deadline,
      'role': role,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      progress: json['progress'].toDouble(),
      deadline: json['deadline'],
      role: json['role'],
      priority: json['priority'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Task {
  final String id;
  String title;
  String priority;
  String dueDate;
  String status;
  String assignedBy;
  DateTime createdAt;
  DateTime updatedAt;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    required this.dueDate,
    required this.status,
    required this.assignedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Task copyWith({
    String? title,
    String? priority,
    String? dueDate,
    String? status,
    String? assignedBy,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      assignedBy: assignedBy ?? this.assignedBy,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'priority': priority,
      'dueDate': dueDate,
      'status': status,
      'assignedBy': assignedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      priority: json['priority'],
      dueDate: json['dueDate'],
      status: json['status'],
      assignedBy: json['assignedBy'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class AssignmentProvider extends ChangeNotifier {
  List<Project> _projects = [];
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Project> get projects => _projects;
  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize with sample data
  void initializeWithSampleData() {
    _projects = [
      Project(
        id: '1',
        name: 'Digital Transformation Initiative',
        status: 'Active',
        progress: 0.75,
        deadline: '2025-09-15',
        role: 'Frontend Developer',
        priority: 'High',
      ),
      Project(
        id: '2',
        name: 'Mobile App Development',
        status: 'Active',
        progress: 0.45,
        deadline: '2025-08-30',
        role: 'Flutter Developer',
        priority: 'Medium',
      ),
      Project(
        id: '3',
        name: 'API Integration Project',
        status: 'Completed',
        progress: 1.0,
        deadline: '2025-06-15',
        role: 'Backend Developer',
        priority: 'Low',
      ),
    ];

    _tasks = [
      Task(
        id: '1',
        title: 'Review code for authentication module',
        priority: 'High',
        dueDate: '2025-07-12',
        status: 'In Progress',
        assignedBy: 'Candra Kurniawan',
      ),
      Task(
        id: '2',
        title: 'Update API documentation',
        priority: 'Medium',
        dueDate: '2025-07-15',
        status: 'Pending',
        assignedBy: 'Candra Kurniawan',
      ),
      Task(
        id: '3',
        title: 'Implement user profile page',
        priority: 'High',
        dueDate: '2025-07-10',
        status: 'Completed',
        assignedBy: 'Candra Kurniawan',
      ),
      Task(
        id: '4',
        title: 'Prepare presentation for sprint review',
        priority: 'Low',
        dueDate: '2025-07-14',
        status: 'Pending',
        assignedBy: 'Team Lead',
      ),
    ];

    notifyListeners();
  }

  // Project CRUD operations
  void addProject(Project project) {
    _projects.add(project);
    notifyListeners();
  }

  void updateProject(String id, Project updatedProject) {
    final index = _projects.indexWhere((project) => project.id == id);
    if (index != -1) {
      _projects[index] = updatedProject;
      notifyListeners();
    }
  }

  void deleteProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    notifyListeners();
  }

  Project? getProjectById(String id) {
    try {
      return _projects.firstWhere((project) => project.id == id);
    } catch (e) {
      return null;
    }
  }

  // Task CRUD operations
  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(String id, Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  // Utility methods
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Generate unique ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Create new project with generated ID
  Project createNewProject({
    required String name,
    required String status,
    required double progress,
    required String deadline,
    required String role,
    required String priority,
  }) {
    return Project(
      id: _generateId(),
      name: name,
      status: status,
      progress: progress,
      deadline: deadline,
      role: role,
      priority: priority,
    );
  }

  // Create new task with generated ID
  Task createNewTask({
    required String title,
    required String priority,
    required String dueDate,
    required String status,
    required String assignedBy,
  }) {
    return Task(
      id: _generateId(),
      title: title,
      priority: priority,
      dueDate: dueDate,
      status: status,
      assignedBy: assignedBy,
    );
  }
}
