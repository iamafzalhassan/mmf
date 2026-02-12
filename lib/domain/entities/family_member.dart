import 'package:mmf/core/utils/data_sanitizer.dart';

class FamilyMember {
  final String age;
  final String alYear;
  final String civilStatus;
  final String fullName;
  final String gender;
  final String mobile;
  final String nationalIdNo;
  final String occupation;
  final String professionalQualificationsDetails;
  final String relationship;
  final String status;
  final String vocationalCourseDetails;
  final String whatsappNo;
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
    required this.fullName,
    required this.gender,
    required this.mobile,
    required this.nationalIdNo,
    required this.occupation,
    required this.professionalQualificationsDetails,
    required this.relationship,
    required this.status,
    required this.vocationalCourseDetails,
    required this.whatsappNo,
    required this.zakath,
    required this.madarasa,
    required this.professionalQualifications,
    required this.schoolEducation,
    required this.specialNeeds,
    required this.ulama,
  });

  Map<String, dynamic> toJson() {
    return {
      'age': DataSanitizer.sanitizeYear(age),
      'alYear': DataSanitizer.sanitizeYear(alYear),
      'civilStatus': DataSanitizer.sanitizeString(civilStatus),
      'fullName': DataSanitizer.sanitizeString(fullName),
      'gender': DataSanitizer.sanitizeString(gender),
      'mobile': DataSanitizer.sanitizePhone(mobile),
      'nationalIdNo': DataSanitizer.sanitizeNIC(nationalIdNo),
      'occupation': DataSanitizer.sanitizeString(occupation),
      'professionalQualificationsDetails': DataSanitizer.sanitizeString(professionalQualificationsDetails),
      'relationship': DataSanitizer.sanitizeString(relationship),
      'status': DataSanitizer.sanitizeString(status),
      'vocationalCourseDetails': DataSanitizer.sanitizeString(vocationalCourseDetails),
      'whatsappNo': DataSanitizer.sanitizePhone(whatsappNo),
      'zakath': DataSanitizer.sanitizeString(zakath),
      'madarasa': DataSanitizer.sanitizeList(madarasa).join(', '),
      'professionalQualifications': DataSanitizer.sanitizeList(professionalQualifications).join(', '),
      'schoolEducation': DataSanitizer.sanitizeList(schoolEducation).join(', '),
      'specialNeeds': DataSanitizer.sanitizeList(specialNeeds).join(', '),
      'ulama': DataSanitizer.sanitizeList(ulama).join(', '),
    };
  }
}