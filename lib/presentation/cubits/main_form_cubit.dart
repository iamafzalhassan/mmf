import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmf/domain/entities/family_member.dart';
import 'package:mmf/domain/entities/main_form.dart';
import 'package:mmf/domain/usecases/submit_form.dart';
import 'package:mmf/presentation/cubits/main_form_state.dart';

class MainFormCubit extends Cubit<MainFormState> {
  static const String headOfFamily = 'Head of Family';

  final SubmitForm submitForm;

  MainFormCubit({required this.submitForm}) : super(MainFormState(refNo: newRefNo()));

  static String newRefNo() => 'KJM-${100000 + Random().nextInt(900000)}';

  void addFamilyMember(FamilyMember member) => emit(state.copyWith(familyMembers: [...state.familyMembers, member]));

  void removeFamilyMember(int index) => emit(state.copyWith(familyMembers: [
        for (final (i, member) in state.familyMembers.indexed)
          if (i != index) member
      ]));

  Future<void> submit({required bool fieldsValid}) async {
    if (state.familyMembers.isEmpty) return reportError('Please add at least one family member.');
    if (!hasExistingHead()) return reportError('Please designate one member as Head of Family.');
    if (!fieldsValid) return;
    emit(state.copyWith(isLoading: true, isSuccess: false));
    final result =
        await submitForm(MainForm(address: state.address, admissionNo: state.admissionNo, familiesCount: state.familiesCount, ownership: state.ownership, refNo: state.refNo, route: state.route, familyMembers: state.familyMembers));
    result.fold((failure) => emit(state.copyWith(isLoading: false, error: failure.message)), (_) => emit(MainFormState(isSuccess: true, refNo: newRefNo())));
  }

  void reportError(String message) {
    emit(state.copyWith());
    emit(state.copyWith(error: message));
  }

  bool hasExistingHead({int? excludeIndex}) => state.familyMembers.indexed.any((entry) => entry.$1 != excludeIndex && entry.$2.relationship == headOfFamily);

  void updateAddress(String value) => emit(state.copyWith(address: value));

  void updateAdmissionNo(String value) => emit(state.copyWith(admissionNo: value));

  void updateFamiliesCount(String value) => emit(state.copyWith(familiesCount: value));

  void updateFamilyMember(int index, FamilyMember member) => emit(state.copyWith(familyMembers: [for (final (i, old) in state.familyMembers.indexed) i == index ? member : old]));

  void updateOwnership(String value) => emit(state.copyWith(ownership: value));

  void updateRoute(String value) => emit(state.copyWith(route: value));
}
