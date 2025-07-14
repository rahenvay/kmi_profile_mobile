import 'package:flutter/foundation.dart';
import '../models/dependent.dart';

class DependentProvider with ChangeNotifier {
  final List<Dependent> _dependents = [];
  bool _isLoading = false;

  List<Dependent> get dependents => List.unmodifiable(_dependents);
  bool get isLoading => _isLoading;

  List<Dependent> get activeDependents => 
      _dependents.where((d) => d.isActive).toList();

  List<Dependent> get inactiveDependents => 
      _dependents.where((d) => !d.isActive).toList();

  List<Dependent> get spouses => 
      _dependents.where((d) => d.relationship.toLowerCase() == 'spouse').toList();

  List<Dependent> get children => 
      _dependents.where((d) => d.relationship.toLowerCase() == 'child').toList();

  List<Dependent> get parents => 
      _dependents.where((d) => ['father', 'mother', 'parent'].contains(d.relationship.toLowerCase())).toList();

  List<Dependent> get emergencyContacts => 
      _dependents.where((d) => d.isEmergencyContact).toList();

  List<Dependent> get insuredDependents => 
      _dependents.where((d) => d.hasInsuranceCoverage).toList();

  List<Dependent> searchDependents(String query) {
    if (query.isEmpty) return _dependents;
    
    final lowercaseQuery = query.toLowerCase();
    return _dependents.where((dependent) =>
      dependent.name.toLowerCase().contains(lowercaseQuery) ||
      dependent.relationship.toLowerCase().contains(lowercaseQuery) ||
      dependent.emailAddress.toLowerCase().contains(lowercaseQuery) ||
      dependent.phoneNumber.contains(query)
    ).toList();
  }

  List<Dependent> getDependentsByRelationship(String relationship) {
    if (relationship.toLowerCase() == 'all') return _dependents;
    return _dependents.where((d) => 
      d.relationship.toLowerCase() == relationship.toLowerCase()).toList();
  }

  List<ImportantDate> getUpcomingDates({int withinDays = 30}) {
    final allDates = <ImportantDate>[];
    
    // Add birthdays
    for (final dependent in _dependents) {
      if (dependent.daysUntilBirthday <= withinDays) {
        allDates.add(ImportantDate(
          id: '${dependent.id}_birthday',
          title: '${dependent.name}\'s Birthday',
          date: dependent.nextBirthday,
          type: 'birthday',
          notes: 'Turning ${dependent.age + 1} years old',
        ));
      }
      
      // Add custom important dates
      for (final date in dependent.importantDates) {
        if (date.daysUntil <= withinDays) {
          allDates.add(date);
        }
      }
    }
    
    // Sort by date
    allDates.sort((a, b) => a.daysUntil.compareTo(b.daysUntil));
    return allDates;
  }

  void addDependent(Dependent dependent) {
    _dependents.add(dependent);
    notifyListeners();
  }

  void updateDependent(String id, Dependent updatedDependent) {
    final index = _dependents.indexWhere((d) => d.id == id);
    if (index != -1) {
      _dependents[index] = updatedDependent;
      notifyListeners();
    }
  }

  void deleteDependent(String id) {
    _dependents.removeWhere((d) => d.id == id);
    notifyListeners();
  }

  Dependent? getDependentById(String id) {
    try {
      return _dependents.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  void initializeWithSampleData() {
    _dependents.clear();
    
    final sampleDependents = [
      Dependent(
        id: '1',
        name: 'Female',
        relationship: 'Spouse',
        birthDate: DateTime(1985, 3, 15),
        gender: 'Female',
        phoneNumber: '+1234567890',
        emailAddress: 'Female12@email.com',
        isActive: true,
        hasInsuranceCoverage: true,
        isEmergencyContact: true,
        importantDates: [
          ImportantDate(
            id: '1_anniversary',
            title: 'Wedding Anniversary',
            date: DateTime(2010, 6, 20),
            type: 'anniversary',
            notes: '15 years of marriage',
          ),
        ],
        notes: 'Primary emergency contact',
      ),
      Dependent(
        id: '2',
        name: 'Michael Jackson',
        relationship: 'Child',
        birthDate: DateTime(2015, 8, 10),
        gender: 'Male',
        phoneNumber: '',
        emailAddress: '',
        isActive: true,
        hasInsuranceCoverage: true,
        isEmergencyContact: false,
        importantDates: [
          ImportantDate(
            id: '2_graduation',
            title: 'Elementary Graduation',
            date: DateTime(2025, 6, 15),
            type: 'graduation',
            notes: 'Graduating from 5th grade',
          ),
        ],
        notes: 'Attends Lincoln Elementary School',
      ),
      Dependent(
        id: '3',
        name: 'Taylor Swift',
        relationship: 'Child',
        birthDate: DateTime(2018, 12, 5),
        gender: 'Female',
        phoneNumber: '',
        emailAddress: '',
        isActive: true,
        hasInsuranceCoverage: true,
        isEmergencyContact: false,
        importantDates: [],
        notes: 'Loves drawing and music',
      ),
      Dependent(
        id: '4',
        name: 'Robert Downey Jr.',
        relationship: 'Father',
        birthDate: DateTime(1955, 4, 22),
        gender: 'Male',
        phoneNumber: '+1987654321',
        emailAddress: 'robert.smith@email.com',
        isActive: true,
        hasInsuranceCoverage: false,
        isEmergencyContact: true,
        importantDates: [],
        notes: 'Retired, lives nearby',
      ),
    ];
    
    _dependents.addAll(sampleDependents);
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
