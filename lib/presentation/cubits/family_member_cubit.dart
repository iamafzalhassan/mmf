import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmf/domain/entities/family_member.dart';

part 'family_member_state.dart';

class FamilyMemberCubit extends Cubit<FamilyMemberState> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController alYearController = TextEditingController();
  final TextEditingController professionalQualificationsDetailsController = TextEditingController(); // New controller
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  FamilyMemberCubit() : super(FamilyMemberState());

  void loadMember(FamilyMember member) {
    nameController.text = member.name;
    nicController.text = member.nic;
    ageController.text = member.age;
    occupationController.text = member.occupation;
    mobileController.text = member.mobile;
    alYearController.text = member.alYear;
    professionalQualificationsDetailsController.text = member.professionalQualificationsDetails;

    emit(FamilyMemberState(
      name: member.name,
      nic: member.nic,
      gender: member.gender,
      civilStatus: member.civilStatus,
      age: member.age,
      relationship: member.relationship,
      occupation: member.occupation,
      status: member.status,
      mobile: member.mobile,
      zakath: member.zakath,
      alYear: member.alYear,
      schoolEducation: member.schoolEducation,
      professionalQualifications: member.professionalQualifications,
      professionalQualificationsDetails: member.professionalQualificationsDetails,
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
    List<String> updatedUlama = List<String>.from(state.ulama);

    if (value == 'Male') {
      updatedUlama.removeWhere((item) => item == 'Hafiza' || item == 'Alima');
    } else if (value == 'Female') {
      updatedUlama.removeWhere((item) => item == 'Hafiz' || item == 'Alim');
    }

    // Reset relationship if it's a gender-specific one
    String updatedRelationship = state.relationship;
    if (value == 'Male') {
      if (['Mother', 'Daughter', 'Sister', 'Granddaughter'].contains(state.relationship)) {
        updatedRelationship = '';
      }
    } else if (value == 'Female') {
      if (['Father', 'Son', 'Brother', 'Grandson'].contains(state.relationship)) {
        updatedRelationship = '';
      }
    }

    emit(state.copyWith(
      gender: value,
      ulama: updatedUlama,
      relationship: updatedRelationship,
    ));
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

  void updateMobile(String value) {
    emit(state.copyWith(mobile: value));
  }

  void updateZakath(String value) {
    emit(state.copyWith(zakath: value));
  }

  void updateAlYear(String value) {
    emit(state.copyWith(alYear: value));
  }

  void updateProfessionalQualificationsDetails(String value) {
    emit(state.copyWith(professionalQualificationsDetails: value));
  }

  void toggleSchoolEducation(String value) {
    final list = List<String>.from(state.schoolEducation);
    if (list.contains(value)) {
      list.remove(value);
      // Clear A/L year if A/L is deselected
      if (value == 'A/L') {
        alYearController.clear();
        emit(state.copyWith(schoolEducation: list, alYear: ''));
        return;
      }
    } else {
      list.add(value);
    }
    emit(state.copyWith(schoolEducation: list));
  }

  void toggleProfessionalQualification(String value) {
    final list = List<String>.from(state.professionalQualifications);
    if (list.contains(value)) {
      list.remove(value);
      // Clear details if all qualifications are removed
      if (list.isEmpty) {
        professionalQualificationsDetailsController.clear();
        emit(state.copyWith(
          professionalQualifications: list,
          professionalQualificationsDetails: '',
        ));
        return;
      }
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
    mobileController.clear();
    alYearController.clear();
    professionalQualificationsDetailsController.clear();
    emit(FamilyMemberState());
  }

  @override
  Future<void> close() {
    nameController.dispose();
    nicController.dispose();
    ageController.dispose();
    occupationController.dispose();
    mobileController.dispose();
    alYearController.dispose();
    professionalQualificationsDetailsController.dispose();
    return super.close();
  }
}