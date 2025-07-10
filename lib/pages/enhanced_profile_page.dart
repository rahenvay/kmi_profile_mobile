import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/employee.dart';

class EnhancedProfilePage extends StatelessWidget {
  final Employee employee;

  const EnhancedProfilePage({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF2A9D01),
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                employee.fullName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: const Color(0xFF2A9D01).withOpacity(0.1),
                        backgroundImage: employee.profileImagePath != null 
                            ? AssetImage(employee.profileImagePath!) 
                            : null,
                        child: employee.profileImagePath == null
                            ? Icon(
                                Icons.person,
                                size: 40,
                                color: const Color(0xFF2A9D01).withOpacity(0.7),
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildQuickInfoCard(),
                const SizedBox(height: 16),
                _buildTabSection(),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildQuickInfoItem(
                  icon: Icons.badge,
                  label: 'ID',
                  value: employee.employeeId,
                ),
              ),
              Expanded(
                child: _buildQuickInfoItem(
                  icon: Icons.work,
                  label: 'Department',
                  value: employee.department,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickInfoItem(
                  icon: Icons.email,
                  label: 'Email',
                  value: employee.emailAddress,
                ),
              ),
              Expanded(
                child: _buildQuickInfoItem(
                  icon: Icons.phone,
                  label: 'Phone',
                  value: employee.cellPhoneNumber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF2A9D01), size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTabSection() {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              labelColor: const Color(0xFF2A9D01),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF2A9D01),
              tabs: const [
                Tab(text: 'Personal'),
                Tab(text: 'Work'),
                Tab(text: 'Contact'),
                Tab(text: 'Other'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 400,
            child: TabBarView(
              children: [
                _buildPersonalTab(),
                _buildWorkTab(),
                _buildContactTab(),
                _buildOtherTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalTab() {
    return SingleChildScrollView(
      child: _buildInfoCard([
        _buildDetailRow(Icons.person, 'Full Name', employee.fullName),
        _buildDetailRow(Icons.transgender, 'Gender', employee.gender),
        _buildDetailRow(Icons.favorite, 'Marital Status', employee.maritalStatus),
        _buildDetailRow(Icons.location_on, 'Birth Place', employee.birthPlace),
        _buildDetailRow(Icons.cake, 'Birth Date', DateFormat('MMM dd, yyyy').format(employee.birthDate)),
      ]),
    );
  }

  Widget _buildWorkTab() {
    return SingleChildScrollView(
      child: _buildInfoCard([
        _buildDetailRow(Icons.badge, 'Employee ID', employee.employeeId),
        _buildDetailRow(Icons.check_circle, 'Status', employee.employeeStatus),
        _buildDetailRow(Icons.date_range, 'Hire Date', DateFormat('MMM dd, yyyy').format(employee.hireDate)),
        if (employee.terminationDate != null)
          _buildDetailRow(Icons.event_busy, 'Termination Date', DateFormat('MMM dd, yyyy').format(employee.terminationDate!)),
        _buildDetailRow(Icons.business, 'Company', employee.company),
        _buildDetailRow(Icons.group, 'Department', employee.department),
        _buildDetailRow(Icons.work, 'Job Title', employee.jobTitle),
        _buildDetailRow(Icons.schedule, 'Employee Type', employee.employeeType),
      ]),
    );
  }

  Widget _buildContactTab() {
    return SingleChildScrollView(
      child: _buildInfoCard([
        _buildDetailRow(Icons.home, 'Home Address', employee.homeAddress),
        _buildDetailRow(Icons.phone_in_talk, 'Home Phone', employee.homePhoneNumber),
        _buildDetailRow(Icons.smartphone, 'Cell Phone', employee.cellPhoneNumber),
        _buildDetailRow(Icons.email, 'Email Address', employee.emailAddress),
      ]),
    );
  }

  Widget _buildOtherTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildInfoCard([
            _buildDetailRow(Icons.account_balance, 'Bank Name', employee.bankName),
            _buildDetailRow(Icons.credit_card, 'Account No', employee.accountNo),
            _buildDetailRow(Icons.person_outline, 'User Name', employee.userName),
            _buildDetailRow(Icons.update, 'Last Updated', DateFormat('MMM dd, yyyy - HH:mm').format(employee.lastUpdated)),
          ]),
          const SizedBox(height: 16),
          _buildDocumentsCard(),
        ],
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF2A9D01)),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description, color: const Color(0xFF2A9D01)),
              const SizedBox(width: 8),
              const Text(
                'Supported Documents',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: employee.supportedDocuments
                .map((document) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A9D01).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF2A9D01).withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_user,
                            size: 16,
                            color: const Color(0xFF2A9D01),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            document,
                            style: const TextStyle(
                              color: Color(0xFF2A9D01),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
