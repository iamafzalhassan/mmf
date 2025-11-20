import 'package:mmf/core/utils/data_sanitizer.dart';

class FamilyMember {
  final String name;
  final String gender;
  final String age;
  final String mobile;
  final String nic;
  final String status;
  final String occupation;
  final String civilStatus;
  final String relationship;
  final String alYear;
  final String zakath;
  final String professionalQualificationsDetails;
  final List<String> schoolEducation;
  final List<String> professionalQualifications;
  final List<String> madarasa;
  final List<String> ulama;
  final List<String> specialNeeds;

  FamilyMember({
    required this.name,
    required this.gender,
    required this.age,
    required this.mobile,
    required this.nic,
    required this.status,
    required this.occupation,
    required this.civilStatus,
    required this.relationship,
    required this.alYear,
    required this.zakath,
    required this.professionalQualificationsDetails,
    required this.schoolEducation,
    required this.professionalQualifications,
    required this.madarasa,
    required this.ulama,
    required this.specialNeeds,
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