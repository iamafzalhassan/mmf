import 'package:mmf/core/utils/data_sanitizer.dart';

class FamilyMember {
  final String age;
  final String alYear;
  final String civilStatus;
  final String gender;
  final String mobile;
  final String name;
  final String nic;
  final String occupation;
  final String professionalQualificationsDetails;
  final String relationship;
  final String status;
  final String zakath;
  final List<String> madarasa;
  final List<String> professionalQualifications;
  final List<String> schoolEducation;
  final List<String> specialNeeds;
  final List<String> ulama;

  FamilyMember({
    required this.age,
    required this.alYear,
    required this.civilStatus,
    required this.gender,
    required this.mobile,
    required this.name,
    required this.nic,
    required this.occupation,
    required this.professionalQualificationsDetails,
    required this.relationship,
    required this.status,
    required this.zakath,
    required this.madarasa,
    required this.professionalQualifications,
    required this.schoolEducation,
    required this.specialNeeds,
    required this.ulama,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': DataSanitizer.sanitizeString(name),
      'gender': DataSanitizer.sanitizeString(gender),
      'age': DataSanitizer.sanitizeYear(age),
      'mobile': DataSanitizer.sanitizePhone(mobile),
      'nic': DataSanitizer.sanitizeNIC(nic),
      'status': DataSanitizer.sanitizeString(status),
      'occupation': DataSanitizer.sanitizeString(occupation),
      'civilStatus': DataSanitizer.sanitizeString(civilStatus),
      'relationship': DataSanitizer.sanitizeString(relationship),
      'alYear': DataSanitizer.sanitizeYear(alYear),
      'zakath': DataSanitizer.sanitizeString(zakath),
      'professionalQualificationsDetails': DataSanitizer.sanitizeString(professionalQualificationsDetails),
      'schoolEducation': DataSanitizer.sanitizeList(schoolEducation).join(', '),
      'professionalQualifications': DataSanitizer.sanitizeList(professionalQualifications).join(', '),
      'madarasa': DataSanitizer.sanitizeList(madarasa).join(', '),
      'ulama': DataSanitizer.sanitizeList(ulama).join(', '),
      'specialNeeds': DataSanitizer.sanitizeList(specialNeeds).join(', '),
    };
  }
}