part of 'family_member_cubit.dart';

class FamilyMemberState {
  final String name;
  final String nic;
  final String gender;
  final String civilStatus;
  final String age;
  final String relationship;
  final String occupation;
  final String status;
  final List<String> students;
  final List<String> madarasa;
  final List<String> ulama;
  final List<String> specialNeeds;

  FamilyMemberState({
    this.name = '',
    this.nic = '',
    this.gender = '',
    this.civilStatus = '',
    this.age = '',
    this.relationship = '',
    this.occupation = '',
    this.status = '',
    this.students = const [],
    this.madarasa = const [],
    this.ulama = const [],
    this.specialNeeds = const [],
  });

  FamilyMemberState copyWith({
    String? name,
    String? nic,
    String? gender,
    String? civilStatus,
    String? age,
    String? relationship,
    String? occupation,
    String? status,
    List<String>? students,
    List<String>? madarasa,
    List<String>? ulama,
    List<String>? specialNeeds,
  }) {
    return FamilyMemberState(
      name: name ?? this.name,
      nic: nic ?? this.nic,
      gender: gender ?? this.gender,
      civilStatus: civilStatus ?? this.civilStatus,
      age: age ?? this.age,
      relationship: relationship ?? this.relationship,
      occupation: occupation ?? this.occupation,
      status: status ?? this.status,
      students: students ?? this.students,
      madarasa: madarasa ?? this.madarasa,
      ulama: ulama ?? this.ulama,
      specialNeeds: specialNeeds ?? this.specialNeeds,
    );
  }

  FamilyMember toEntity() {
    return FamilyMember(
      name: name,
      nic: nic,
      gender: gender,
      civilStatus: civilStatus,
      age: age,
      relationship: relationship,
      occupation: occupation,
      status: status,
      students: students,
      madarasa: madarasa,
      ulama: ulama,
      specialNeeds: specialNeeds,
    );
  }
}