import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmf/domain/entities/family_member.dart';

part 'family_member_state.dart';

class FamilyMemberCubit extends Cubit<FamilyMemberState> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController ageController = TextEditingController();
  final TextEditingController alYearController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController professionalQualificationsDetailsController = TextEditingController();

  FamilyMemberCubit() : super(FamilyMemberState());

  void loadMember(FamilyMember member) {
    ageController.text = member.age;
    alYearController.text = member.alYear;
    mobileController.text = member.mobile;
    nameController.text = member.name;
    nicController.text = member.nic;
    occupationController.text = member.occupation;
    professionalQualificationsDetailsController.text = member.professionalQualificationsDetails;

    emit(FamilyMemberState(
      age: member.age,
      alYear: member.alYear,
      civilStatus: member.civilStatus,
      gender: member.gender,
      mobile: member.mobile,
      name: member.name,
      nic: member.nic,
      occupation: member.occupation,
      professionalQualificationsDetails: member.professionalQualificationsDetails,
      relationship: member.relationship,
      status: member.status,
      zakath: member.zakath,
      madarasa: member.madarasa,
      professionalQualifications: member.professionalQualifications,
      schoolEducation: member.schoolEducation,
      specialNeeds: member.specialNeeds,
      ulama: member.ulama,
    ));
  }

  void updateAge(String value) {
    emit(state.copyWith(age: value));
  }

  void updateAlYear(String value) {
    emit(state.copyWith(alYear: value));
  }

  void updateCivilStatus(String value) {
    emit(state.copyWith(civilStatus: value));
  }

  void updateGender(String value) {
    List<String> updatedUlama = List<String>.from(state.ulama);

    if (value == 'Male') {
      updatedUlama.removeWhere((item) => item == 'Hafiza' || item == 'Alima');
    } else if (value == 'Female') {
      updatedUlama.removeWhere((item) => item == 'Hafiz' || item == 'Alim');
    }

    String updatedRelationship = state.relationship;
    if (value == 'Male') {
      if (['Mother', 'Daughter', 'Sister', 'Granddaughter']
          .contains(state.relationship)) {
        updatedRelationship = '';
      }
    } else if (value == 'Female') {
      if (['Father', 'Son', 'Brother', 'Grandson']
          .contains(state.relationship)) {
        updatedRelationship = '';
      }
    }

    emit(state.copyWith(
      gender: value,
      relationship: updatedRelationship,
      ulama: updatedUlama,
    ));
  }

  void updateMobile(String value) {
    emit(state.copyWith(mobile: value));
  }

  void updateName(String value) {
    emit(state.copyWith(name: value));
  }

  void updateNic(String value) {
    emit(state.copyWith(nic: value));
  }

  void updateOccupation(String value) {
    emit(state.copyWith(occupation: value));
  }

  void updateProfessionalQualificationsDetails(String value) {
    emit(state.copyWith(professionalQualificationsDetails: value));
  }

  void updateRelationship(String value) {
    emit(state.copyWith(relationship: value));
  }

  void updateStatus(String value) {
    emit(state.copyWith(status: value));
  }

  void updateZakath(String value) {
    emit(state.copyWith(zakath: value));
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

  void toggleProfessionalQualification(String value) {
    final list = List<String>.from(state.professionalQualifications);
    if (list.contains(value)) {
      list.remove(value);
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

  void toggleSchoolEducation(String value) {
    final list = List<String>.from(state.schoolEducation);
    if (list.contains(value)) {
      list.remove(value);
      if (value == 'A/L') {
        alYearController.clear();
        emit(state.copyWith(
          alYear: '',
          schoolEducation: list,
        ));
        return;
      }
    } else {
      list.add(value);
    }
    emit(state.copyWith(schoolEducation: list));
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

  void toggleUlama(String value) {
    final list = List<String>.from(state.ulama);
    if (list.contains(value)) {
      list.remove(value);
    } else {
      list.add(value);
    }
    emit(state.copyWith(ulama: list));
  }

  bool validateAndSave() {
    return formKey.currentState?.validate() ?? false;
  }

  void reset() {
    ageController.clear();
    alYearController.clear();
    mobileController.clear();
    nameController.clear();
    nicController.clear();
    occupationController.clear();
    professionalQualificationsDetailsController.clear();
    emit(FamilyMemberState());
  }

  @override
  Future<void> close() {
    ageController.dispose();
    alYearController.dispose();
    mobileController.dispose();
    nameController.dispose();
    nicController.dispose();
    occupationController.dispose();
    professionalQualificationsDetailsController.dispose();
    return super.close();
  }
}