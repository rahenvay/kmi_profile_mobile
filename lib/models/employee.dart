class Employee {
  final String fullName;
  final String employeeId;
  final String employeeStatus;
  final DateTime hireDate;
  final DateTime? terminationDate;
  final String company;
  final String department;
  final String jobTitle;
  final String employeeType;
  final String gender;
  final String maritalStatus;
  final String birthPlace;
  final DateTime birthDate;
  final String homeAddress;
  final String homePhoneNumber;
  final String cellPhoneNumber;
  final String emailAddress;
  final String bankName;
  final String accountNo;
  final String userName;
  final List<String> supportedDocuments;
  final DateTime lastUpdated;
  final String? profileImagePath;
  
  // Employment timeline fields
  final String? probationNotes7Days;
  final String? probationNotes3Months;
  final String? probationNotes6Months;
  final String? resignationNotes;
  
  // Emergency contact fields
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? emergencyContactEmail;
  final String? emergencyContactRelationship;

  Employee({
    required this.fullName,
    required this.employeeId,
    required this.employeeStatus,
    required this.hireDate,
    this.terminationDate,
    required this.company,
    required this.department,
    required this.jobTitle,
    required this.employeeType,
    required this.gender,
    required this.maritalStatus,
    required this.birthPlace,
    required this.birthDate,
    required this.homeAddress,
    required this.homePhoneNumber,
    required this.cellPhoneNumber,
    required this.emailAddress,
    required this.bankName,
    required this.accountNo,
    required this.userName,
    required this.supportedDocuments,
    required this.lastUpdated,
    this.profileImagePath,
    this.probationNotes7Days,
    this.probationNotes3Months,
    this.probationNotes6Months,
    this.resignationNotes,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.emergencyContactEmail,
    this.emergencyContactRelationship,
  });

  factory Employee.sample() {
    return Employee(
      fullName: "Rahenvay Naibaho",
      employeeId: "00000228",
      employeeStatus: "Active",
      hireDate: DateTime(2025, 7, 1),
      terminationDate: DateTime(2025, 12, 30),
      company: "Kamoro Maxima Integra",
      department: "Consulting",
      jobTitle: "Developer",
      employeeType: "Magang",
      gender: "Male",
      maritalStatus: "Single",
      birthPlace: "asd",
      birthDate: DateTime(2004, 6, 20),
      homeAddress: "asd, asd, asd, 12345",
      homePhoneNumber: "-",
      cellPhoneNumber: "091211223344",
      emailAddress: "rahenvay_naibaho@kamoro.com",
      bankName: "BCA",
      accountNo: "1234567898",
      userName: "rahenvay_naibaho@kamoro.com",
      supportedDocuments: [
        "KK",
        "KTP"
      ],
      lastUpdated: DateTime.now(),
      profileImagePath: null,
      probationNotes7Days: "Initial orientation completed successfully. Employee shows good potential.",
      probationNotes3Months: "Demonstrates strong technical skills and adapts well to team dynamics.",
      probationNotes6Months: "Excellent performance during probation period. Ready for full employment.",
      resignationNotes: null,
      emergencyContactName: "Naibaho",
      emergencyContactPhone: "081234567890",
      emergencyContactEmail: ".naibaho@gmail.com",
      emergencyContactRelationship: "Ayah ",
    );
  }

  /// Create Employee from JSON (for API responses)
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      fullName: json['fullName'] ?? '',
      employeeId: json['employeeId'] ?? '',
      employeeStatus: json['employeeStatus'] ?? '',
      hireDate: json['hireDate'] != null 
        ? DateTime.parse(json['hireDate']) 
        : DateTime.now(),
      terminationDate: json['terminationDate'] != null 
        ? DateTime.parse(json['terminationDate']) 
        : null,
      company: json['company'] ?? '',
      department: json['department'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      employeeType: json['employeeType'] ?? '',
      gender: json['gender'] ?? '',
      maritalStatus: json['maritalStatus'] ?? '',
      birthPlace: json['birthPlace'] ?? '',
      birthDate: json['birthDate'] != null 
        ? DateTime.parse(json['birthDate']) 
        : DateTime.now(),
      homeAddress: json['homeAddress'] ?? '',
      homePhoneNumber: json['homePhoneNumber'] ?? '',
      cellPhoneNumber: json['cellPhoneNumber'] ?? '',
      emailAddress: json['emailAddress'] ?? '',
      bankName: json['bankName'] ?? '',
      accountNo: json['accountNo'] ?? '',
      userName: json['userName'] ?? '',
      supportedDocuments: json['supportedDocuments'] != null 
        ? List<String>.from(json['supportedDocuments']) 
        : [],
      lastUpdated: json['lastUpdated'] != null 
        ? DateTime.parse(json['lastUpdated']) 
        : DateTime.now(),
      profileImagePath: json['profileImagePath'],
      probationNotes7Days: json['probationNotes7Days'],
      probationNotes3Months: json['probationNotes3Months'],
      probationNotes6Months: json['probationNotes6Months'],
      resignationNotes: json['resignationNotes'],
      emergencyContactName: json['emergencyContactName'],
      emergencyContactPhone: json['emergencyContactPhone'],
      emergencyContactEmail: json['emergencyContactEmail'],
      emergencyContactRelationship: json['emergencyContactRelationship'],
    );
  }

  /// Convert Employee to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'employeeId': employeeId,
      'employeeStatus': employeeStatus,
      'hireDate': hireDate.toIso8601String(),
      'terminationDate': terminationDate?.toIso8601String(),
      'company': company,
      'department': department,
      'jobTitle': jobTitle,
      'employeeType': employeeType,
      'gender': gender,
      'maritalStatus': maritalStatus,
      'birthPlace': birthPlace,
      'birthDate': birthDate.toIso8601String(),
      'homeAddress': homeAddress,
      'homePhoneNumber': homePhoneNumber,
      'cellPhoneNumber': cellPhoneNumber,
      'emailAddress': emailAddress,
      'bankName': bankName,
      'accountNo': accountNo,
      'userName': userName,
      'supportedDocuments': supportedDocuments,
      'lastUpdated': lastUpdated.toIso8601String(),
      'profileImagePath': profileImagePath,
      'probationNotes7Days': probationNotes7Days,
      'probationNotes3Months': probationNotes3Months,
      'probationNotes6Months': probationNotes6Months,
      'resignationNotes': resignationNotes,
      'emergencyContactName': emergencyContactName,
      'emergencyContactPhone': emergencyContactPhone,
      'emergencyContactEmail': emergencyContactEmail,
      'emergencyContactRelationship': emergencyContactRelationship,
    };
  }
}
