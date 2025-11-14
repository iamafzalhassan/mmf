import 'family_member.dart';

class FormData {
  final String refNo;
  final String admissionNo;
  final String address;
  final String mobile;
  final String ownership;
  final String zakath;
  final List<FamilyMember> familyMembers;

  FormData({
    required this.refNo,
    required this.admissionNo,
    required this.address,
    required this.mobile,
    required this.ownership,
    required this.zakath,
    required this.familyMembers,
  });

  Map<String, dynamic> toJson() {
    return {
      'refNo': refNo,
      'admissionNo': admissionNo,
      'address': address,
      'mobile': mobile,
      'ownership': ownership,
      'zakath': zakath,
      'familyMembers': familyMembers.map((m) => m.toJson()).toList(),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}