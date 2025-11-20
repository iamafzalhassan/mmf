import 'package:mmf/core/utils/data_sanitizer.dart';
import 'family_member.dart';

class FormData {
  final String refNo;
  final String admissionNo;
  final String address;
  final String ownership;
  final String familiesCount;
  final List<FamilyMember> familyMembers;

  FormData({
    required this.refNo,
    required this.admissionNo,
    required this.address,
    required this.ownership,
    required this.familiesCount,
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