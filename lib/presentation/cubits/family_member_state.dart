part of 'family_member_cubit.dart';

class FamilyMemberState {
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
  final String zakath;
  final List<String> madarasaEducation;
  final List<String> professionalQualifications;
  final List<String> schoolEducation;
  final List<String> specialNeeds;
  final List<String> ulamaQualifications;

  FamilyMemberState({
    this.age = '',
    this.alYear = '',
    this.civilStatus = '',
    this.fullName = '',
    this.gender = '',
    this.mobile = '',
    this.nationalIdNo = '',
    this.occupation = '',
    this.professionalQualificationsDetails = '',
    this.relationship = '',
    this.status = '',
    this.zakath = '',
    this.madarasaEducation = const [],
    this.professionalQualifications = const [],
    this.schoolEducation = const [],
    this.specialNeeds = const [],
    this.ulamaQualifications = const [],
  });

  FamilyMemberState copyWith({
    String? age,
    String? alYear,
    String? civilStatus,
    String? fullName,
    String? gender,
    String? mobile,
    String? nationalIdNo,
    String? occupation,
    String? professionalQualificationsDetails,
    String? relationship,
    String? status,
    String? zakath,
    List<String>? madarasaEducation,
    List<String>? professionalQualifications,
    List<String>? schoolEducation,
    List<String>? specialNeeds,
    List<String>? ulamaQualifications,
  }) {
    return FamilyMemberState(
      age: age ?? this.age,
      alYear: alYear ?? this.alYear,
      civilStatus: civilStatus ?? this.civilStatus,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      mobile: mobile ?? this.mobile,
      nationalIdNo: nationalIdNo ?? this.nationalIdNo,
      occupation: occupation ?? this.occupation,
      professionalQualificationsDetails:
      professionalQualificationsDetails ?? this.professionalQualificationsDetails,
      relationship: relationship ?? this.relationship,
      status: status ?? this.status,
      zakath: zakath ?? this.zakath,
      madarasaEducation: madarasaEducation ?? this.madarasaEducation,
      professionalQualifications: professionalQualifications ?? this.professionalQualifications,
      schoolEducation: schoolEducation ?? this.schoolEducation,
      specialNeeds: specialNeeds ?? this.specialNeeds,
      ulamaQualifications: ulamaQualifications ?? this.ulamaQualifications,
    );
  }

  FamilyMember toEntity() {
    return FamilyMember(
      age: age,
      alYear: alYear,
      civilStatus: civilStatus,
      fullName: fullName,
      gender: gender,
      mobile: mobile,
      nationalIdNo: nationalIdNo,
      occupation: occupation,
      professionalQualificationsDetails: professionalQualificationsDetails,
      relationship: relationship,
      status: status,
      zakath: zakath,
      madarasa: madarasaEducation,
      professionalQualifications: professionalQualifications,
      schoolEducation: schoolEducation,
      specialNeeds: specialNeeds,
      ulama: ulamaQualifications,
    );
  }
}