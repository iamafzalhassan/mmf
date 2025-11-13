import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmf/domain/entities/family_member.dart';

part 'family_member_state.dart';

class FamilyMemberCubit extends Cubit<FamilyMemberState> {
  FamilyMemberCubit() : super(FamilyMemberState());

  void updateName(String value) {
    emit(state.copyWith(name: value));
  }

  void updateNic(String value) {
    emit(state.copyWith(nic: value));
  }

  void updateGender(String value) {
    emit(state.copyWith(gender: value));
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

  void updateStatus(String value) {
    emit(state.copyWith(status: value));
  }

  void toggleStudent(String value) {
    final list = List<String>.from(state.students);
    if (list.contains(value)) {
      list.remove(value);
    } else {
      list.add(value);
    }
    emit(state.copyWith(students: list));
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

  void toggleUlma(String value) {
    final list = List<String>.from(state.ulma);
    if (list.contains(value)) {
      list.remove(value);
    } else {
      list.add(value);
    }
    emit(state.copyWith(ulma: list));
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

  void reset() {
    emit(FamilyMemberState());
  }
}