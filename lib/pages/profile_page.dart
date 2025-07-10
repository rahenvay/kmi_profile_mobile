import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/employee.dart';

class ProfilePage extends StatelessWidget {
  final Employee employee;

  const ProfilePage({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Employee Profile'),
        backgroundColor: const Color(0xFF2A9D01),
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildInfoSection('Personal Information', [
              _buildInfoRow('Full Name', employee.fullName),
              _buildInfoRow('Employee ID', employee.employeeId),
              _buildInfoRow('Gender', employee.gender),
              _buildInfoRow('Marital Status', employee.maritalStatus),
              _buildInfoRow('Birth Place', employee.birthPlace),
              _buildInfoRow('Birth Date', DateFormat('MMM dd, yyyy').format(employee.birthDate)),
            ]),
            const SizedBox(height: 16),
            _buildInfoSection('Employment Details', [
              _buildInfoRow('Employee Status', employee.employeeStatus),
              _buildInfoRow('Hire Date', DateFormat('MMM dd, yyyy').format(employee.hireDate)),
              if (employee.terminationDate != null)
                _buildInfoRow('Termination Date', DateFormat('MMM dd, yyyy').format(employee.terminationDate!)),
              _buildInfoRow('Company', employee.company),
              _buildInfoRow('Department', employee.department),
              _buildInfoRow('Job Title', employee.jobTitle),
              _buildInfoRow('Employee Type', employee.employeeType),
            ]),
            const SizedBox(height: 16),
            _buildInfoSection('Contact Information', [
              _buildInfoRow('Home Address', employee.homeAddress),
              _buildInfoRow('Home Phone', employee.homePhoneNumber),
              _buildInfoRow('Cell Phone', employee.cellPhoneNumber),
              _buildInfoRow('Email Address', employee.emailAddress),
            ]),
            const SizedBox(height: 16),
            _buildInfoSection('Banking Information', [
              _buildInfoRow('Bank Name', employee.bankName),
              _buildInfoRow('Account No', employee.accountNo),
            ]),
            const SizedBox(height: 16),
            _buildInfoSection('System Information', [
              _buildInfoRow('User Name', employee.userName),
              _buildInfoRow('Last Updated', DateFormat('MMM dd, yyyy - HH:mm').format(employee.lastUpdated)),
            ]),
            const SizedBox(height: 16),
            _buildDocumentsSection(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2A9D01),
            const Color(0xFF228701),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2A9D01).withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background decoration
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture with enhanced styling
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFF2A9D01).withOpacity(0.1),
                      backgroundImage: employee.profileImagePath != null 
                          ? AssetImage(employee.profileImagePath!) 
                          : null,
                      child: employee.profileImagePath == null
                          ? Icon(
                              Icons.person,
                              size: 55,
                              color: const Color(0xFF2A9D01).withOpacity(0.7),
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Name immediately under profile picture
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    employee.fullName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 6),
                // Employee ID right under the name
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    'ID: ${employee.employeeId}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Job title with better styling
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      employee.jobTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Status badge with better positioning
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: employee.employeeStatus == 'Active' 
                            ? Colors.green.shade400 
                            : Colors.red.shade400,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: (employee.employeeStatus == 'Active' 
                                ? Colors.green 
                                : Colors.red).withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            employee.employeeStatus == 'Active' 
                                ? Icons.check_circle 
                                : Icons.cancel,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            employee.employeeStatus,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2A9D01),
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          const Text(': '),
          Expanded(
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

  Widget _buildDocumentsSection() {
    return Container(
      width: double.infinity,
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
          const Text(
            'Supported Documents',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2A9D01),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: employee.supportedDocuments
                .map((document) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A9D01).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF2A9D01).withOpacity(0.3)),
                      ),
                      child: Text(
                        document,
                        style: const TextStyle(
                          color: Color(0xFF2A9D01),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
