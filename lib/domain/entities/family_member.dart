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
  final List<String> schoolEducation;
  final List<String> professionalQualifications;
  final List<String> madarasa;
  final List<String> ulama;
  final List<String> specialNeeds;
  final String zakath;

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
    required this.schoolEducation,
    required this.professionalQualifications,
    required this.madarasa,
    required this.ulama,
    required this.specialNeeds,
    required this.zakath,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender': gender,
      'age': age,
      'mobile': mobile,
      'nic': nic,
      'status': status,
      'occupation': occupation,
      'civilStatus': civilStatus,
      'relationship': relationship,
      'schoolEducation': schoolEducation.join(', '),
      'professionalQualifications': professionalQualifications.join(', '),
      'madarasa': madarasa.join(', '),
      'ulama': ulama.join(', '),
      'specialNeeds': specialNeeds.join(', '),
      'zakath': zakath,
    };
  }
}