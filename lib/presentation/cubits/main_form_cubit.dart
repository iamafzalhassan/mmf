import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmf/core/utils/date_utils.dart';
import 'package:mmf/domain/entities/family_member.dart';
import 'package:mmf/domain/entities/main_form.dart';
import 'package:mmf/domain/usecases/submit_form.dart';
import 'package:mmf/presentation/cubits/main_form_state.dart';

class MainFormCubit extends Cubit<MainFormState> {
  static const String headOfFamily = 'Head of Family';

  final SubmitForm submitForm;

  MainFormCubit({required this.submitForm}) : super(MainFormState(refNo: DateTimeUtils.generateRefNo()));

  void addFamilyMember(FamilyMember member) {
    final updatedMembers = List<FamilyMember>.from(state.familyMembers)..add(member);
    emit(state.copyWith(familyMembers: updatedMembers));
  }

  void clearError() => emit(state.copyWith(error: null));

  void clearFamilyMembers() => emit(state.copyWith(familyMembers: []));

  bool hasExistingHead({int? excludeIndex}) => state.familyMembers.asMap().entries.any((entry) {
        if (excludeIndex != null && entry.key == excludeIndex) {
          return false;
        }
        return entry.value.relationship == headOfFamily;
      });

  void removeFamilyMember(int index) {
    if (index >= 0 && index < state.familyMembers.length) {
      final updatedMembers = List<FamilyMember>.from(state.familyMembers)..removeAt(index);
      emit(state.copyWith(familyMembers: updatedMembers));
    }
  }

  Future<void> submit({required bool fieldsValid}) async {
    if (state.familyMembers.isEmpty) {
      reportError('Please add at least one family member.');
      return;
    }

    if (!state.familyMembers.any((m) => m.relationship == headOfFamily)) {
      reportError('Please designate one member as Head of Family.');
      return;
    }

    if (!fieldsValid) return;

    emit(state.copyWith(isLoading: true, isSuccess: false, error: null));

    final mainForm = MainForm(address: state.address, admissionNo: state.admissionNo, familiesCount: state.familiesCount, ownership: state.ownership, refNo: state.refNo, route: state.route, familyMembers: state.familyMembers);

    final result = await submitForm(mainForm);

    result.fold((failure) => emit(state.copyWith(isLoading: false, error: failure.message)), (_) => resetForm());
  }

  void reportError(String message) {
    emit(state.copyWith(error: null));
    emit(state.copyWith(error: message));
  }

  void resetForm() => emit(state.copyWith(isLoading: false, isSuccess: true, address: '', admissionNo: '', familiesCount: '', ownership: '', refNo: DateTimeUtils.generateRefNo(), route: '', error: null, familyMembers: []));

  void updateAddress(String value) => emit(state.copyWith(address: value));

  void updateAdmissionNo(String value) => emit(state.copyWith(admissionNo: value));

  void updateFamiliesCount(String value) => emit(state.copyWith(familiesCount: value));

  void updateFamilyMember(int index, FamilyMember member) {
    if (index >= 0 && index < state.familyMembers.length) {
      final updatedMembers = List<FamilyMember>.from(state.familyMembers);
      updatedMembers[index] = member;
      emit(state.copyWith(familyMembers: updatedMembers));
    }
  }

  void updateOwnership(String value) => emit(state.copyWith(ownership: value));

  void updateRefNo(String value) => emit(state.copyWith(refNo: value));

  void updateRoute(String value) => emit(state.copyWith(route: value));
}
