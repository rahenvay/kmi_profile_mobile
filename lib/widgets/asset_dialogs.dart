import 'package:flutter/material.dart';
import '../providers/asset_provider.dart';

class AssetFormDialog extends StatefulWidget {
  final Asset? asset; // null for add, asset instance for edit
  final Function(Asset) onSave;

  const AssetFormDialog({
    super.key,
    this.asset,
    required this.onSave,
  });

  @override
  State<AssetFormDialog> createState() => _AssetFormDialogState();
}

class _AssetFormDialogState extends State<AssetFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _assetIdController = TextEditingController();
  final _detailController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _selectedType = 'Laptop';

  final List<String> _assetTypes = [
    'Laptop',
    'Desktop Computer',
    'Monitor',
    'Mobile Phone',
    'Tablet',
    'Keyboard',
    'Mouse',
    'Headset',
    'Webcam',
    'Printer',
    'Access Card',
    'Vehicle',
    'Software License',
    'Hardware Tool',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.asset != null) {
      // Edit mode - populate fields
      _selectedType = widget.asset!.type;
      _assetIdController.text = widget.asset!.assetId;
      _detailController.text = widget.asset!.detail;
      _startDateController.text = widget.asset!.startDate;
      _endDateController.text = widget.asset!.endDate;
      _notesController.text = widget.asset!.notes;
    }
  }

  @override
  void dispose() {
    _assetIdController.dispose();
    _detailController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.asset != null;
    
    return AlertDialog(
      title: Text(
        isEditing ? 'Edit Asset' : 'Add New Asset',
        style: const TextStyle(
          color: Color(0xFF2A9D01),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: IntrinsicHeight(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                // Asset Type Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Asset Type',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: _assetTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Asset ID
                TextFormField(
                  controller: _assetIdController,
                  decoration: const InputDecoration(
                    labelText: 'Asset ID',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.tag),
                    hintText: 'e.g., LAP-001, MON-024',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter asset ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Detail
                TextFormField(
                  controller: _detailController,
                  decoration: const InputDecoration(
                    labelText: 'Asset Details',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                    hintText: 'Brand, model, specifications, etc.',
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter asset details';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Start Date
                TextFormField(
                  controller: _startDateController,
                  decoration: const InputDecoration(
                    labelText: 'Start Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                    hintText: 'YYYY-MM-DD',
                  ),
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                    );
                    if (date != null) {
                      _startDateController.text = 
                          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                    }
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please select start date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // End Date
                TextFormField(
                  controller: _endDateController,
                  decoration: const InputDecoration(
                    labelText: 'End Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.event),
                    hintText: 'YYYY-MM-DD',
                  ),
                  readOnly: true,
                  onTap: () async {
                    final startDateText = _startDateController.text;
                    DateTime initialDate = DateTime.now().add(const Duration(days: 365));
                    
                    if (startDateText.isNotEmpty) {
                      final startDate = DateTime.tryParse(startDateText);
                      if (startDate != null) {
                        initialDate = startDate.add(const Duration(days: 365));
                      }
                    }
                    
                    final date = await showDatePicker(
                      context: context,
                      initialDate: initialDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
                    );
                    if (date != null) {
                      _endDateController.text = 
                          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                    }
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please select end date';
                    }
                    
                    // Validate that end date is after start date
                    final startDate = DateTime.tryParse(_startDateController.text);
                    final endDate = DateTime.tryParse(value);
                    
                    if (startDate != null && endDate != null) {
                      if (endDate.isBefore(startDate) || endDate.isAtSameMomentAs(startDate)) {
                        return 'End date must be after start date';
                      }
                    }
                    
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Notes
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.note),
                    hintText: 'Additional information, conditions, etc.',
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter notes or additional information';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveAsset,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2A9D01),
            foregroundColor: Colors.white,
          ),
          child: Text(isEditing ? 'Update' : 'Add'),
        ),
      ],
    );
  }

  void _saveAsset() {
    if (_formKey.currentState!.validate()) {
      final asset = Asset(
        id: widget.asset?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        type: _selectedType,
        assetId: _assetIdController.text.trim(),
        detail: _detailController.text.trim(),
        startDate: _startDateController.text.trim(),
        endDate: _endDateController.text.trim(),
        notes: _notesController.text.trim(),
        createdAt: widget.asset?.createdAt ?? DateTime.now(),
      );

      widget.onSave(asset);
      Navigator.of(context).pop();
    }
  }
}
