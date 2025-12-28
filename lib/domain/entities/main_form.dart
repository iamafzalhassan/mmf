import 'package:mmf/core/utils/data_sanitizer.dart';
import 'family_member.dart';

class MainForm {
  final String address;
  final String admissionNo;
  final String familiesCount;
  final String ownership;
  final String refNo;
  final List<FamilyMember> familyMembers;

  MainForm({
    required this.address,
    required this.admissionNo,
    required this.familiesCount,
    required this.ownership,
    required this.refNo,
    required this.familyMembers,
  });

  Map<String, dynamic> toJson() {
    return {
      'refNo': DataSanitizer.sanitizeString(refNo),
      'admissionNo': DataSanitizer.sanitizeAdmissionNo(admissionNo),
      'address': DataSanitizer.sanitizeAddress(address),
      'ownership': DataSanitizer.sanitizeString(ownership),
      'familiesCount': DataSanitizer.sanitizeFamiliesCount(familiesCount),
      'familyMembers': familyMembers.map((m) => m.toJson()).toList(),
    };
  }
}