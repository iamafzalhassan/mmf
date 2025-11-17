class FamilyMember {
  final String name;
  final String nic;
  final String gender;
  final String civilStatus;
  final String age;
  final String relationship;
  final String occupation;
  final String status;
  final String mobile;
  final String zakath;
  final List<String> schoolEducation;
  final List<String> professionalQualifications;
  final List<String> madarasa;
  final List<String> ulama;
  final List<String> specialNeeds;

  FamilyMember({
    required this.name,
    required this.nic,
    required this.gender,
    required this.civilStatus,
    required this.age,
    required this.relationship,
    required this.occupation,
    required this.status,
    required this.mobile,
    required this.zakath,
    required this.schoolEducation,
    required this.professionalQualifications,
    required this.madarasa,
    required this.ulama,
    required this.specialNeeds,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nic': nic,
      'gender': gender,
      'civilStatus': civilStatus,
      'age': age,
      'relationship': relationship,
      'occupation': occupation,
      'status': status,
      'mobile': mobile,
      'zakath': zakath,
      'schoolEducation': schoolEducation.join(', '),
      'professionalQualifications': professionalQualifications.join(', '),
      'madarasa': madarasa.join(', '),
      'ulama': ulama.join(', '),
      'specialNeeds': specialNeeds.join(', '),
    };
  }
}