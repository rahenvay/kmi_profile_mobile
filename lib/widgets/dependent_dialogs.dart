import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/dependent.dart';

class DependentFormDialog extends StatefulWidget {
  final Dependent? dependent;
  final Function(Dependent) onSave;

  const DependentFormDialog({
    super.key,
    this.dependent,
    required this.onSave,
  });

  @override
  State<DependentFormDialog> createState() => _DependentFormDialogState();
}

class _DependentFormDialogState extends State<DependentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _selectedRelationship = 'Child';
  String _selectedGender = 'Male';
  DateTime _selectedDate = DateTime.now().subtract(const Duration(days: 365));
  bool _isActive = true;
  bool _hasInsurance = false;
  bool _isEmergencyContact = false;

  final List<String> _relationships = [
    'Spouse', 'Child', 'Father', 'Mother', 'Parent', 'Sibling', 'Other'
  ];

  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    if (widget.dependent != null) {
      _initializeWithExistingData();
    }
  }

  void _initializeWithExistingData() {
    final dependent = widget.dependent!;
    _nameController.text = dependent.name;
    _phoneController.text = dependent.phoneNumber;
    _emailController.text = dependent.emailAddress;
    _notesController.text = dependent.notes;
    _selectedRelationship = dependent.relationship;
    _selectedGender = dependent.gender;
    _selectedDate = dependent.birthDate;
    _isActive = dependent.isActive;
    _hasInsurance = dependent.hasInsuranceCoverage;
    _isEmergencyContact = dependent.isEmergencyContact;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.family_restroom,
                  color: const Color(0xFF2A9D01),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.dependent == null ? 'Add Dependent' : 'Edit Dependent',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2A9D01),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        icon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the dependent\'s name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildDropdownField(
                        label: 'Relationship',
                        icon: Icons.family_restroom,
                        value: _selectedRelationship,
                        items: _relationships,
                        onChanged: (value) {
                          setState(() {
                            _selectedRelationship = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildDateField(),
                      const SizedBox(height: 16),
                      _buildDropdownField(
                        label: 'Gender',
                        icon: Icons.transgender,
                        value: _selectedGender,
                        items: _genders,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email Address',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      _buildSwitchTiles(),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _notesController,
                        label: 'Notes',
                        icon: Icons.note,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveDependent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A9D01),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(widget.dependent == null ? 'Add' : 'Update'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF2A9D01)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2A9D01), width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF2A9D01)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2A9D01), width: 2),
        ),
      ),
      items: items.map((item) => DropdownMenuItem(
        value: item,
        child: Text(item),
      )).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: _selectDate,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Color(0xFF2A9D01)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Birth Date',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  DateFormat('MMM dd, yyyy').format(_selectedDate),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTiles() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Active Status'),
          subtitle: const Text('Is this dependent currently active?'),
          value: _isActive,
          activeColor: const Color(0xFF2A9D01),
          onChanged: (value) {
            setState(() {
              _isActive = value;
            });
          },
        ),
        SwitchListTile(
          title: const Text('Insurance Coverage'),
          subtitle: const Text('Does this dependent have insurance coverage?'),
          value: _hasInsurance,
          activeColor: const Color(0xFF2A9D01),
          onChanged: (value) {
            setState(() {
              _hasInsurance = value;
            });
          },
        ),
        SwitchListTile(
          title: const Text('Emergency Contact'),
          subtitle: const Text('Can this dependent be contacted in emergencies?'),
          value: _isEmergencyContact,
          activeColor: const Color(0xFF2A9D01),
          onChanged: (value) {
            setState(() {
              _isEmergencyContact = value;
            });
          },
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2A9D01),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveDependent() {
    if (_formKey.currentState!.validate()) {
      final dependent = Dependent(
        id: widget.dependent?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        relationship: _selectedRelationship,
        birthDate: _selectedDate,
        gender: _selectedGender,
        phoneNumber: _phoneController.text.trim(),
        emailAddress: _emailController.text.trim(),
        isActive: _isActive,
        hasInsuranceCoverage: _hasInsurance,
        isEmergencyContact: _isEmergencyContact,
        importantDates: widget.dependent?.importantDates ?? [],
        notes: _notesController.text.trim(),
      );

      widget.onSave(dependent);
      Navigator.of(context).pop();
    }
  }
}

class ImportantDateDialog extends StatefulWidget {
  final ImportantDate? importantDate;
  final Function(ImportantDate) onSave;

  const ImportantDateDialog({
    super.key,
    this.importantDate,
    required this.onSave,
  });

  @override
  State<ImportantDateDialog> createState() => _ImportantDateDialogState();
}

class _ImportantDateDialogState extends State<ImportantDateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _selectedType = 'custom';
  DateTime _selectedDate = DateTime.now();

  final List<String> _dateTypes = [
    'custom', 'anniversary', 'graduation', 'appointment'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.importantDate != null) {
      _initializeWithExistingData();
    }
  }

  void _initializeWithExistingData() {
    final date = widget.importantDate!;
    _titleController.text = date.title;
    _notesController.text = date.notes;
    _selectedType = date.type;
    _selectedDate = date.date;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.event,
                  color: Color(0xFF2A9D01),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.importantDate == null ? 'Add Important Date' : 'Edit Important Date',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2A9D01),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      prefixIcon: const Icon(Icons.title, color: Color(0xFF2A9D01)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: InputDecoration(
                      labelText: 'Type',
                      prefixIcon: const Icon(Icons.category, color: Color(0xFF2A9D01)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: _dateTypes.map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type.toUpperCase()),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Color(0xFF2A9D01)),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Date',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                DateFormat('MMM dd, yyyy').format(_selectedDate),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Notes',
                      prefixIcon: const Icon(Icons.note, color: Color(0xFF2A9D01)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveImportantDate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A9D01),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(widget.importantDate == null ? 'Add' : 'Update'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2A9D01),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveImportantDate() {
    if (_formKey.currentState!.validate()) {
      final importantDate = ImportantDate(
        id: widget.importantDate?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        date: _selectedDate,
        type: _selectedType,
        notes: _notesController.text.trim(),
      );

      widget.onSave(importantDate);
      Navigator.of(context).pop();
    }
  }
}
