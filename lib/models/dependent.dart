class Dependent {
  final String id;
  final String name;
  final String relationship;
  final DateTime birthDate;
  final String gender;
  final String phoneNumber;
  final String emailAddress;
  final bool isActive;
  final bool hasInsuranceCoverage;
  final bool isEmergencyContact;
  final List<ImportantDate> importantDates;
  final String notes;

  Dependent({
    required this.id,
    required this.name,
    required this.relationship,
    required this.birthDate,
    required this.gender,
    this.phoneNumber = '',
    this.emailAddress = '',
    this.isActive = true,
    this.hasInsuranceCoverage = false,
    this.isEmergencyContact = false,
    this.importantDates = const [],
    this.notes = '',
  });

  int get age {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || 
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  DateTime get nextBirthday {
    final now = DateTime.now();
    DateTime birthday = DateTime(now.year, birthDate.month, birthDate.day);
    if (birthday.isBefore(now)) {
      birthday = DateTime(now.year + 1, birthDate.month, birthDate.day);
    }
    return birthday;
  }

  int get daysUntilBirthday {
    final now = DateTime.now();
    return nextBirthday.difference(now).inDays;
  }

  Dependent copyWith({
    String? id,
    String? name,
    String? relationship,
    DateTime? birthDate,
    String? gender,
    String? phoneNumber,
    String? emailAddress,
    bool? isActive,
    bool? hasInsuranceCoverage,
    bool? isEmergencyContact,
    List<ImportantDate>? importantDates,
    String? notes,
  }) {
    return Dependent(
      id: id ?? this.id,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emailAddress: emailAddress ?? this.emailAddress,
      isActive: isActive ?? this.isActive,
      hasInsuranceCoverage: hasInsuranceCoverage ?? this.hasInsuranceCoverage,
      isEmergencyContact: isEmergencyContact ?? this.isEmergencyContact,
      importantDates: importantDates ?? this.importantDates,
      notes: notes ?? this.notes,
    );
  }
}

class ImportantDate {
  final String id;
  final String title;
  final DateTime date;
  final String type; // 'birthday', 'anniversary', 'graduation', 'custom'
  final String notes;

  ImportantDate({
    required this.id,
    required this.title,
    required this.date,
    required this.type,
    this.notes = '',
  });

  int get daysUntil {
    final now = DateTime.now();
    DateTime nextOccurrence = DateTime(now.year, date.month, date.day);
    if (nextOccurrence.isBefore(now)) {
      nextOccurrence = DateTime(now.year + 1, date.month, date.day);
    }
    return nextOccurrence.difference(now).inDays;
  }

  ImportantDate copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? type,
    String? notes,
  }) {
    return ImportantDate(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      type: type ?? this.type,
      notes: notes ?? this.notes,
    );
  }
}
