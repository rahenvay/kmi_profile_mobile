import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/employee_data_provider.dart';
import '../providers/assignment_provider.dart';
import '../providers/theme_provider.dart';
import '../models/employee.dart';
import '../widgets/assignment_dialogs.dart';

class AssignmentPage extends StatefulWidget {
  const AssignmentPage({super.key});

  @override
  State<AssignmentPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Assignments'),
            backgroundColor: themeProvider.accentColor,
            foregroundColor: Colors.white,
            automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.work), text: 'Current'),
            Tab(icon: Icon(Icons.folder_open), text: 'Projects'),
            Tab(icon: Icon(Icons.task_alt), text: 'Tasks'),
            Tab(icon: Icon(Icons.history), text: 'History'),
          ],
        ),
      ),
      body: Consumer<EmployeeDataProvider>(
        builder: (context, employeeProvider, child) {
          if (employeeProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF2A9D01),
              ),
            );
          }

          if (employeeProvider.currentEmployee == null) {
            return const Center(
              child: Text(
                'No employee data available',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildCurrentAssignmentTab(employeeProvider.currentEmployee!),
              _buildProjectsTab(),
              _buildTasksTab(),
              _buildHistoryTab(employeeProvider.currentEmployee!),
            ],
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return Consumer<AssignmentProvider>(
      builder: (context, provider, child) {
        return FloatingActionButton(
          heroTag: "assignment_fab", // Unique hero tag
          backgroundColor: const Color(0xFF2A9D01),
          onPressed: () => _showAddOptionsDialog(),
          child: const Icon(Icons.add, color: Colors.white),
        );
      },
    );
  }

  void _showAddOptionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Add New',
          style: TextStyle(
            color: Color(0xFF2A9D01),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.folder_open, color: Color(0xFF2A9D01)),
              title: const Text('Add Project'),
              onTap: () {
                Navigator.of(context).pop();
                _showProjectDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.task_alt, color: Color(0xFF2A9D01)),
              title: const Text('Add Task'),
              onTap: () {
                Navigator.of(context).pop();
                _showTaskDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showProjectDialog({Project? project}) {
    showDialog(
      context: context,
      builder: (context) => ProjectFormDialog(
        project: project,
        onSave: (project) {
          final assignmentProvider = Provider.of<AssignmentProvider>(context, listen: false);
          if (project.id.isNotEmpty && assignmentProvider.getProjectById(project.id) != null) {
            // Update existing project
            assignmentProvider.updateProject(project.id, project);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Project updated successfully!'),
                backgroundColor: Color(0xFF2A9D01),
              ),
            );
          } else {
            // Add new project
            assignmentProvider.addProject(project);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Project added successfully!'),
                backgroundColor: Color(0xFF2A9D01),
              ),
            );
          }
        },
      ),
    );
  }

  void _showTaskDialog({Task? task}) {
    showDialog(
      context: context,
      builder: (context) => TaskFormDialog(
        task: task,
        onSave: (task) {
          final assignmentProvider = Provider.of<AssignmentProvider>(context, listen: false);
          if (task.id.isNotEmpty && assignmentProvider.getTaskById(task.id) != null) {
            // Update existing task
            assignmentProvider.updateTask(task.id, task);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Task updated successfully!'),
                backgroundColor: Color(0xFF2A9D01),
              ),
            );
          } else {
            // Add new task
            assignmentProvider.addTask(task);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Task added successfully!'),
                backgroundColor: Color(0xFF2A9D01),
              ),
            );
          }
        },
      ),
    );
  }

  void _deleteProject(String projectId, String projectName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project'),
        content: Text('Are you sure you want to delete "$projectName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<AssignmentProvider>(context, listen: false).deleteProject(projectId);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Project deleted successfully!'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteTask(String taskId, String taskTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "$taskTitle"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<AssignmentProvider>(context, listen: false).deleteTask(taskId);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Task deleted successfully!'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentAssignmentTab(Employee employee) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Role Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A9D01).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.badge,
                          color: Color(0xFF2A9D01),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Current Role',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              employee.jobTitle,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2A9D01),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildInfoRow('Department', employee.department, Icons.business),
                  const SizedBox(height: 12),
                  _buildInfoRow('Company', employee.company, Icons.corporate_fare),
                  const SizedBox(height: 12),
                  _buildInfoRow('Employee Type', employee.employeeType, Icons.person_outline),
                  const SizedBox(height: 12),
                  _buildInfoRow('Status', employee.employeeStatus, Icons.check_circle),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Work Location Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A9D01).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Color(0xFF2A9D01),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Work Location',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Primary Office', 'Jakarta Headquarters', Icons.business),
                  const SizedBox(height: 12),
                  _buildInfoRow('Work Mode', 'WFH', Icons.work),
                  const SizedBox(height: 12),
                  _buildInfoRow('Remote Days', 'Monday - Friday', Icons.home),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Reporting Structure Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A9D01).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.account_tree,
                          color: Color(0xFF2A9D01),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Reporting Structure',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Direct Manager', 'Candra Kurniawan', Icons.person),
                  const SizedBox(height: 12),
                  _buildInfoRow('Team Lead', 'Candra Kurniawan', Icons.supervised_user_circle),
                  const SizedBox(height: 12),
                  _buildInfoRow('Team Size', '5 Members', Icons.group),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsTab() {
    return Consumer<AssignmentProvider>(
      builder: (context, assignmentProvider, child) {
        final projects = assignmentProvider.projects;

        if (projects.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder_open,
                  size: 80,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No projects yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Tap the + button to add your first project',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            project.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            switch (value) {
                              case 'edit':
                                _showProjectDialog(project: project);
                                break;
                              case 'delete':
                                _deleteProject(project.id, project.name);
                                break;
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, color: Color(0xFF2A9D01)),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Delete'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildStatusChip(project.status),
                        const SizedBox(width: 8),
                        _buildPriorityChip(project.priority),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.person, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          project.role,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          'Due: ${project.deadline}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: project.progress,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2A9D01)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${(project.progress * 100).toInt()}%',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
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

  Widget _buildTasksTab() {
    return Consumer<AssignmentProvider>(
      builder: (context, assignmentProvider, child) {
        final tasks = assignmentProvider.tasks;

        if (tasks.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.task_alt,
                  size: 80,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No tasks yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Tap the + button to add your first task',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getPriorityColor(task.priority),
                  child: Text(
                    task.priority[0],
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  task.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('Assigned by: ${task.assignedBy}'),
                    Text('Due: ${task.dueDate}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStatusChip(task.status),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            _showTaskDialog(task: task);
                            break;
                          case 'delete':
                            _deleteTask(task.id, task.title);
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Color(0xFF2A9D01)),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete'),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildHistoryTab(Employee employee) {
    return Consumer<AssignmentProvider>(
      builder: (context, assignmentProvider, child) {
        // Combine projects and tasks for history
        final history = <Map<String, dynamic>>[];

        // Add projects to history
        for (final project in assignmentProvider.projects) {
          history.add({
            'date': project.createdAt.toString().split(' ')[0],
            'type': 'Project Assignment',
            'description': 'Assigned to project: ${project.name}',
            'icon': Icons.folder_open,
          });
        }

        // Add tasks to history
        for (final task in assignmentProvider.tasks) {
          history.add({
            'date': task.createdAt.toString().split(' ')[0],
            'type': 'Task Assignment',
            'description': 'Assigned task: ${task.title}',
            'icon': Icons.task_alt,
          });
        }

        // Add employee-related history
        history.addAll([
          {
            'date': '2025-07-01',
            'type': 'Role Assignment',
            'description': 'Assigned as ${employee.jobTitle} in ${employee.department}',
            'icon': Icons.work,
          },
          {
            'date': '2025-06-15',
            'type': 'Training Assignment',
            'description': 'Completed Flutter Development Course',
            'icon': Icons.school,
          },
          {
            'date': '2025-06-01',
            'type': 'Team Assignment',
            'description': 'Joined Mobile Development Team',
            'icon': Icons.group,
          },
        ]);

        // Sort by date (newest first)
        history.sort((a, b) => b['date'].compareTo(a['date']));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: history.length,
          itemBuilder: (context, index) {
            final item = history[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF2A9D01),
                  child: Icon(
                    item['icon'] as IconData,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                title: Text(
                  item['type'] as String,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(item['description'] as String),
                    const SizedBox(height: 4),
                    Text(
                      item['date'] as String,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
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

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'active':
      case 'in progress':
        backgroundColor = const Color(0xFF2A9D01).withOpacity(0.1);
        textColor = const Color(0xFF2A9D01);
        break;
      case 'completed':
        backgroundColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue;
        break;
      case 'pending':
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        break;
      case 'on hold':
        backgroundColor = Colors.purple.withOpacity(0.1);
        textColor = Colors.purple;
        break;
      case 'cancelled':
        backgroundColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPriorityChip(String priority) {
    Color backgroundColor;
    Color textColor;

    switch (priority.toLowerCase()) {
      case 'high':
        backgroundColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        break;
      case 'medium':
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        break;
      case 'low':
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        priority,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
