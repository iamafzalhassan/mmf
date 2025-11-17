import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmf/domain/entities/family_member.dart';

part 'family_member_state.dart';

class FamilyMemberCubit extends Cubit<FamilyMemberState> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  FamilyMemberCubit() : super(FamilyMemberState());

  // Initialize with existing member data for editing
  void loadMember(FamilyMember member) {
    nameController.text = member.name;
    nicController.text = member.nic;
    ageController.text = member.age;
    occupationController.text = member.occupation;

    emit(FamilyMemberState(
      name: member.name,
      nic: member.nic,
      gender: member.gender,
      civilStatus: member.civilStatus,
      age: member.age,
      relationship: member.relationship,
      occupation: member.occupation,
      status: member.status,
      schoolEducation: member.schoolEducation,
      professionalQualifications: member.professionalQualifications,
      madarasa: member.madarasa,
      ulama: member.ulama,
      specialNeeds: member.specialNeeds,
    ));
  }

  void updateName(String value) {
    emit(state.copyWith(name: value));
  }

  void updateNic(String value) {
    emit(state.copyWith(nic: value));
  }

  void updateGender(String value) {
    // Clear ulama selections that don't match the new gender
    List<String> updatedUlama = List<String>.from(state.ulama);

    if (value == 'Male') {
      // Remove female-specific qualifications
      updatedUlama.removeWhere((item) => item == 'Hafiza' || item == 'Alima');
    } else if (value == 'Female') {
      // Remove male-specific qualifications
      updatedUlama.removeWhere((item) => item == 'Hafiz' || item == 'Alim');
    }

    emit(state.copyWith(gender: value, ulama: updatedUlama));
  }

  void updateCivilStatus(String value) {
    emit(state.copyWith(civilStatus: value));
  }

  void updateAge(String value) {
    emit(state.copyWith(age: value));
  }

  void updateRelationship(String value) {
    emit(state.copyWith(relationship: value));
  }

  void updateOccupation(String value) {
    emit(state.copyWith(occupation: value));
  }

  void updateStatus(String value) {
    emit(state.copyWith(status: value));
  }

  void toggleSchoolEducation(String value) {
    final list = List<String>.from(state.schoolEducation);
    if (list.contains(value)) {
      list.remove(value);
    } else {
      list.add(value);
    }
    emit(state.copyWith(schoolEducation: list));
  }

  void toggleProfessionalQualification(String value) {
    final list = List<String>.from(state.professionalQualifications);
    if (list.contains(value)) {
      list.remove(value);
    } else {
      list.add(value);
    }
    emit(state.copyWith(professionalQualifications: list));
  }

  void toggleMadarasa(String value) {
    final list = List<String>.from(state.madarasa);
    if (list.contains(value)) {
      list.remove(value);
    } else {
      list.add(value);
    }
    emit(state.copyWith(madarasa: list));
  }

  void toggleUlama(String value) {
    final list = List<String>.from(state.ulama);
    if (list.contains(value)) {
      list.remove(value);
    } else {
      list.add(value);
    }
    emit(state.copyWith(ulama: list));
  }

  void toggleSpecialNeeds(String value) {
    final list = List<String>.from(state.specialNeeds);
    if (list.contains(value)) {
      list.remove(value);
    } else {
      list.add(value);
    }
    emit(state.copyWith(specialNeeds: list));
  }

  bool validateAndSave() {
    return formKey.currentState?.validate() ?? false;
  }

  void reset() {
    nameController.clear();
    nicController.clear();
    ageController.clear();
    occupationController.clear();
    emit(FamilyMemberState());
  }

  @override
  Future<void> close() {
    nameController.dispose();
    nicController.dispose();
    ageController.dispose();
    occupationController.dispose();
    return super.close();
  }
}