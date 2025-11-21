part of 'family_member_cubit.dart';

class FamilyMemberState {
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

  FamilyMemberState({
    this.age = '',
    this.alYear = '',
    this.civilStatus = '',
    this.gender = '',
    this.mobile = '',
    this.name = '',
    this.nic = '',
    this.occupation = '',
    this.professionalQualificationsDetails = '',
    this.relationship = '',
    this.status = '',
    this.zakath = '',
    this.madarasa = const [],
    this.professionalQualifications = const [],
    this.schoolEducation = const [],
    this.specialNeeds = const [],
    this.ulama = const [],
  });

  FamilyMemberState copyWith({
    String? age,
    String? alYear,
    String? civilStatus,
    String? gender,
    String? mobile,
    String? name,
    String? nic,
    String? occupation,
    String? professionalQualificationsDetails,
    String? relationship,
    String? status,
    String? zakath,
    List<String>? madarasa,
    List<String>? professionalQualifications,
    List<String>? schoolEducation,
    List<String>? specialNeeds,
    List<String>? ulama,
  }) {
    return FamilyMemberState(
      age: age ?? this.age,
      alYear: alYear ?? this.alYear,
      civilStatus: civilStatus ?? this.civilStatus,
      gender: gender ?? this.gender,
      mobile: mobile ?? this.mobile,
      name: name ?? this.name,
      nic: nic ?? this.nic,
      occupation: occupation ?? this.occupation,
      professionalQualificationsDetails:
      professionalQualificationsDetails ?? this.professionalQualificationsDetails,
      relationship: relationship ?? this.relationship,
      status: status ?? this.status,
      zakath: zakath ?? this.zakath,
      madarasa: madarasa ?? this.madarasa,
      professionalQualifications:
      professionalQualifications ?? this.professionalQualifications,
      schoolEducation: schoolEducation ?? this.schoolEducation,
      specialNeeds: specialNeeds ?? this.specialNeeds,
      ulama: ulama ?? this.ulama,
    );
  }

  FamilyMember toEntity() {
    return FamilyMember(
      age: age,
      alYear: alYear,
      civilStatus: civilStatus,
      gender: gender,
      mobile: mobile,
      name: name,
      nic: nic,
      occupation: occupation,
      professionalQualificationsDetails: professionalQualificationsDetails,
      relationship: relationship,
      status: status,
      zakath: zakath,
      madarasa: madarasa,
      professionalQualifications: professionalQualifications,
      schoolEducation: schoolEducation,
      specialNeeds: specialNeeds,
      ulama: ulama,
    );
  }
}