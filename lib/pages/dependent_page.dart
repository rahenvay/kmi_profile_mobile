import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/dependent_provider.dart';
import '../models/dependent.dart';
import '../widgets/dependent_dialogs.dart';

class DependentPage extends StatefulWidget {
  const DependentPage({super.key});

  @override
  State<DependentPage> createState() => _DependentPageState();
}

class _DependentPageState extends State<DependentPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dependents'),
        backgroundColor: const Color(0xFF2A9D01),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search dependents...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              // Tab Bar
              TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                isScrollable: true,
                tabs: const [
                  Tab(icon: Icon(Icons.people), text: 'All'),
                  Tab(icon: Icon(Icons.favorite), text: 'Spouse'),
                  Tab(icon: Icon(Icons.child_care), text: 'Children'),
                  Tab(icon: Icon(Icons.elderly), text: 'Parents'),
                  Tab(icon: Icon(Icons.event), text: 'Dates'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Consumer<DependentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF2A9D01),
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildDependentList(provider.searchDependents(_searchQuery), 'All Dependents'),
              _buildDependentList(provider.spouses.where((dependent) => 
                _searchQuery.isEmpty || _matchesSearch(dependent, _searchQuery)).toList(), 'Spouses'),
              _buildDependentList(provider.children.where((dependent) => 
                _searchQuery.isEmpty || _matchesSearch(dependent, _searchQuery)).toList(), 'Children'),
              _buildDependentList(provider.parents.where((dependent) => 
                _searchQuery.isEmpty || _matchesSearch(dependent, _searchQuery)).toList(), 'Parents'),
              _buildImportantDatesList(provider),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF2A9D01),
        onPressed: _showDependentDialog,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Dependent', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  bool _matchesSearch(Dependent dependent, String query) {
    final lowercaseQuery = query.toLowerCase();
    return dependent.name.toLowerCase().contains(lowercaseQuery) ||
           dependent.relationship.toLowerCase().contains(lowercaseQuery) ||
           dependent.emailAddress.toLowerCase().contains(lowercaseQuery) ||
           dependent.phoneNumber.contains(query);
  }

  Widget _buildDependentList(List<Dependent> dependents, String title) {
    if (dependents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.family_restroom,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty ? 'No dependents found' : 'No ${title.toLowerCase()}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty 
                  ? 'Try different search terms'
                  : 'Tap the + button to add your first dependent',
              style: const TextStyle(
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
      itemCount: dependents.length,
      itemBuilder: (context, index) {
        final dependent = dependents[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: _getRelationshipColor(dependent.relationship).withOpacity(0.1),
                      child: Icon(
                        _getRelationshipIcon(dependent.relationship),
                        color: _getRelationshipColor(dependent.relationship),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dependent.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${dependent.relationship} • Age ${dependent.age}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(dependent.isActive ? 'Active' : 'Inactive'),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            _showDependentDialog(dependent: dependent);
                            break;
                          case 'delete':
                            _deleteDependent(dependent.id, dependent.name);
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
                const SizedBox(height: 12),
                
                // Basic Info
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoRow(Icons.cake, 'Birthday', 
                        DateFormat('MMM dd, yyyy').format(dependent.birthDate)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoRow(Icons.transgender, 'Gender', dependent.gender),
                    ),
                  ],
                ),
                
                if (dependent.phoneNumber.isNotEmpty || dependent.emailAddress.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  if (dependent.phoneNumber.isNotEmpty)
                    _buildInfoRow(Icons.phone, 'Phone', dependent.phoneNumber),
                  if (dependent.emailAddress.isNotEmpty)
                    _buildInfoRow(Icons.email, 'Email', dependent.emailAddress),
                ],

                const SizedBox(height: 12),

                // Status Badges
                Wrap(
                  spacing: 8,
                  children: [
                    if (dependent.hasInsuranceCoverage)
                      _buildBadge('Insurance Covered', Icons.medical_services, Colors.blue),
                    if (dependent.isEmergencyContact)
                      _buildBadge('Emergency Contact', Icons.contact_emergency, Colors.red),
                    _buildBadge('Next Birthday in ${dependent.daysUntilBirthday} days', 
                      Icons.cake, Colors.orange),
                  ],
                ),

                if (dependent.notes.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      dependent.notes,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImportantDatesList(DependentProvider provider) {
    final upcomingDates = provider.getUpcomingDates();
    
    if (upcomingDates.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_available,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No Upcoming Important Dates',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Add dependents to see their important dates',
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
      itemCount: upcomingDates.length,
      itemBuilder: (context, index) {
        final date = upcomingDates[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getDateTypeColor(date.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getDateTypeIcon(date.type),
                    color: _getDateTypeColor(date.type),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        date.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('MMM dd, yyyy').format(date.date),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (date.notes.isNotEmpty)
                        Text(
                          date.notes,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: date.daysUntil == 0 ? Colors.red.withOpacity(0.1) :
                           date.daysUntil <= 7 ? Colors.orange.withOpacity(0.1) :
                           Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    date.daysUntil == 0 ? 'Today' :
                    date.daysUntil == 1 ? 'Tomorrow' :
                    '${date.daysUntil} days',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: date.daysUntil == 0 ? Colors.red :
                             date.daysUntil <= 7 ? Colors.orange :
                             Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'active':
        backgroundColor = const Color(0xFF2A9D01).withOpacity(0.1);
        textColor = const Color(0xFF2A9D01);
        break;
      case 'inactive':
        backgroundColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  IconData _getRelationshipIcon(String relationship) {
    switch (relationship.toLowerCase()) {
      case 'spouse':
        return Icons.favorite;
      case 'child':
        return Icons.child_care;
      case 'father':
      case 'mother':
      case 'parent':
        return Icons.elderly;
      case 'sibling':
        return Icons.people;
      default:
        return Icons.person;
    }
  }

  Color _getRelationshipColor(String relationship) {
    switch (relationship.toLowerCase()) {
      case 'spouse':
        return Colors.pink;
      case 'child':
        return Colors.blue;
      case 'father':
      case 'mother':
      case 'parent':
        return Colors.brown;
      case 'sibling':
        return Colors.purple;
      default:
        return const Color(0xFF2A9D01);
    }
  }

  IconData _getDateTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'birthday':
        return Icons.cake;
      case 'anniversary':
        return Icons.favorite;
      case 'graduation':
        return Icons.school;
      case 'appointment':
        return Icons.medical_services;
      default:
        return Icons.event;
    }
  }

  Color _getDateTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'birthday':
        return Colors.orange;
      case 'anniversary':
        return Colors.pink;
      case 'graduation':
        return Colors.blue;
      case 'appointment':
        return Colors.green;
      default:
        return const Color(0xFF2A9D01);
    }
  }

  void _showDependentDialog({Dependent? dependent}) {
    showDialog(
      context: context,
      builder: (context) => DependentFormDialog(
        dependent: dependent,
        onSave: (dependent) {
          final dependentProvider = Provider.of<DependentProvider>(context, listen: false);
          if (dependent.id.isNotEmpty && dependentProvider.getDependentById(dependent.id) != null) {
            // Update existing dependent
            dependentProvider.updateDependent(dependent.id, dependent);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Dependent updated successfully!'),
                backgroundColor: Color(0xFF2A9D01),
              ),
            );
          } else {
            // Add new dependent
            dependentProvider.addDependent(dependent);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Dependent added successfully!'),
                backgroundColor: Color(0xFF2A9D01),
              ),
            );
          }
        },
      ),
    );
  }

  void _deleteDependent(String dependentId, String dependentName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Dependent'),
        content: Text('Are you sure you want to delete "$dependentName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<DependentProvider>(context, listen: false).deleteDependent(dependentId);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Dependent deleted successfully!'),
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
}
