class Asset {
  final String id;
  final String type; // laptop, phone, etc.
  final String assetId;
  final String detail;
  final String startDate;
  final String endDate;
  final String notes;
  final DateTime createdAt;

  Asset({
    required this.id,
    required this.type,
    required this.assetId,
    required this.detail,
    required this.startDate,
    required this.endDate,
    required this.notes,
    required this.createdAt,
  });

  // Copy with method for editing
  Asset copyWith({
    String? id,
    String? type,
    String? assetId,
    String? detail,
    String? startDate,
    String? endDate,
    String? notes,
    DateTime? createdAt,
  }) {
    return Asset(
      id: id ?? this.id,
      type: type ?? this.type,
      assetId: assetId ?? this.assetId,
      detail: detail ?? this.detail,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
