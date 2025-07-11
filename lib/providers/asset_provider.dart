import 'package:flutter/foundation.dart';

class Asset {
  final String id;
  String type;
  String assetId;
  String detail;
  String startDate;
  String endDate;
  String notes;
  DateTime createdAt;
  DateTime updatedAt;

  Asset({
    required this.id,
    required this.type,
    required this.assetId,
    required this.detail,
    required this.startDate,
    required this.endDate,
    required this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Asset copyWith({
    String? type,
    String? assetId,
    String? detail,
    String? startDate,
    String? endDate,
    String? notes,
  }) {
    return Asset(
      id: id,
      type: type ?? this.type,
      assetId: assetId ?? this.assetId,
      detail: detail ?? this.detail,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'assetId': assetId,
      'detail': detail,
      'startDate': startDate,
      'endDate': endDate,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'],
      type: json['type'],
      assetId: json['assetId'],
      detail: json['detail'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Helper method to check if asset is currently active
  bool get isActive {
    final now = DateTime.now();
    final start = DateTime.tryParse(startDate);
    final end = DateTime.tryParse(endDate);
    
    if (start == null || end == null) return false;
    
    return now.isAfter(start) && now.isBefore(end);
  }

  // Helper method to get status
  String get status {
    final now = DateTime.now();
    final start = DateTime.tryParse(startDate);
    final end = DateTime.tryParse(endDate);
    
    if (start == null || end == null) return 'Invalid Dates';
    
    if (now.isBefore(start)) return 'Upcoming';
    if (now.isAfter(end)) return 'Expired';
    return 'Active';
  }
}

class AssetProvider extends ChangeNotifier {
  List<Asset> _assets = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Asset> get assets => _assets;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get assets by status
  List<Asset> get activeAssets => _assets.where((asset) => asset.isActive).toList();
  List<Asset> get expiredAssets => _assets.where((asset) => asset.status == 'Expired').toList();
  List<Asset> get upcomingAssets => _assets.where((asset) => asset.status == 'Upcoming').toList();

  // Initialize with sample data
  void initializeWithSampleData() {
    _assets = [
      Asset(
        id: '1',
        type: 'Laptop',
        assetId: 'LAP-001',
        detail: 'Lenovo B4400 i5-4200M, RAM 10 GB, 256 SSD',
        startDate: '2025-07-15',
        endDate: '2025-08-15',
        notes: 'Primary work laptop assigned for development work',
      ),
      Asset(
        id: '2',
        type: 'Monitor',
        assetId: 'MON-024',
        detail: 'LG UltraWide 34" 4K Monitor',
        startDate: '2025-02-01',
        endDate: '2026-02-01',
        notes: 'Secondary display for enhanced productivity',
      ),
      Asset(
        id: '3',
        type: 'Mobile Phone',
        assetId: 'PH-156',
        detail: 'iPhone 14 Pro - 256GB',
        startDate: '2024-12-01',
        endDate: '2025-12-01',
        notes: 'Company phone for business communications',
      ),
    ];

    notifyListeners();
  }

  // Asset CRUD operations
  void addAsset(Asset asset) {
    _assets.add(asset);
    notifyListeners();
  }

  void updateAsset(String id, Asset updatedAsset) {
    final index = _assets.indexWhere((asset) => asset.id == id);
    if (index != -1) {
      _assets[index] = updatedAsset;
      notifyListeners();
    }
  }

  void deleteAsset(String id) {
    _assets.removeWhere((asset) => asset.id == id);
    notifyListeners();
  }

  Asset? getAssetById(String id) {
    try {
      return _assets.firstWhere((asset) => asset.id == id);
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

  // Create new asset with generated ID
  Asset createNewAsset({
    required String type,
    required String assetId,
    required String detail,
    required String startDate,
    required String endDate,
    required String notes,
  }) {
    return Asset(
      id: _generateId(),
      type: type,
      assetId: assetId,
      detail: detail,
      startDate: startDate,
      endDate: endDate,
      notes: notes,
    );
  }

  // Get asset count by type
  Map<String, int> getAssetCountByType() {
    final Map<String, int> counts = {};
    for (final asset in _assets) {
      counts[asset.type] = (counts[asset.type] ?? 0) + 1;
    }
    return counts;
  }

  // Search assets
  List<Asset> searchAssets(String query) {
    if (query.isEmpty) return _assets;
    
    final lowercaseQuery = query.toLowerCase();
    return _assets.where((asset) =>
      asset.type.toLowerCase().contains(lowercaseQuery) ||
      asset.assetId.toLowerCase().contains(lowercaseQuery) ||
      asset.detail.toLowerCase().contains(lowercaseQuery) ||
      asset.notes.toLowerCase().contains(lowercaseQuery)
    ).toList();
  }
}
