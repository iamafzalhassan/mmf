import 'family_member.dart';

class FormData {
  final String refNo;
  final String admissionNo;
  final String headName;
  final String headInitials;
  final String address;
  final String headNIC;
  final String headAge;
  final String mobile;
  final String occupation;
  final String headGender;
  final String headCivilStatus;
  final String ownership;
  final String zakath;
  final List<FamilyMember> familyMembers;

  FormData({
    required this.refNo,
    required this.admissionNo,
    required this.headName,
    required this.headInitials,
    required this.address,
    required this.headNIC,
    required this.headAge,
    required this.mobile,
    required this.occupation,
    required this.headGender,
    required this.headCivilStatus,
    required this.ownership,
    required this.zakath,
    required this.familyMembers,
  });

  Map<String, dynamic> toJson() {
    return {
      'refNo': refNo,
      'admissionNo': admissionNo,
      'headName': headName,
      'headInitials': headInitials,
      'address': address,
      'headNIC': headNIC,
      'headAge': headAge,
      'mobile': mobile,
      'occupation': occupation,
      'headGender': headGender,
      'headCivilStatus': headCivilStatus,
      'ownership': ownership,
      'zakath': zakath,
      'familyMembers': familyMembers.map((m) => m.toJson()).toList(),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}