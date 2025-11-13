class FamilyMember {
  final String name;
  final String nic;
  final String gender;
  final String civilStatus;
  final String age;
  final String relationship;
  final String status;
  final List<String> students;
  final List<String> madarasa;
  final List<String> ulma;
  final List<String> specialNeeds;

  FamilyMember({
    required this.name,
    required this.nic,
    required this.gender,
    required this.civilStatus,
    required this.age,
    required this.relationship,
    required this.status,
    required this.students,
    required this.madarasa,
    required this.ulma,
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
      'status': status,
      'students': students.join(', '),
      'madarasa': madarasa.join(', '),
      'ulma': ulma.join(', '),
      'specialNeeds': specialNeeds.join(', '),
    };
  }
}