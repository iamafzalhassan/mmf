import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmf/core/utils/date_utils.dart';
import 'package:mmf/domain/entities/family_member.dart';
import 'package:mmf/domain/entities/form_data.dart';
import 'package:mmf/domain/usecases/submit_form.dart';
import 'package:mmf/presentation/cubits/main_form_state.dart';

class MainFormCubit extends Cubit<MainFormState> {
  final SubmitForm submitForm;

  MainFormCubit({required this.submitForm}) : super(MainFormState.initial());

  // Main form fields
  void updateRefNo(String value) {
    emit(state.copyWith(refNo: value));
  }

  void updateAdmissionNo(String value) {
    emit(state.copyWith(admissionNo: value));
  }

  void updateAddress(String value) {
    emit(state.copyWith(address: value));
  }

  void updateMobile(String value) {
    emit(state.copyWith(mobile: value));
  }

  void updateOwnership(String value) {
    emit(state.copyWith(ownership: value));
  }

  void updateZakath(String value) {
    emit(state.copyWith(zakath: value));
  }

  // Family members management
  void addFamilyMember(FamilyMember member) {
    final updatedMembers = List<FamilyMember>.from(state.familyMembers)
      ..add(member);
    emit(state.copyWith(familyMembers: updatedMembers));
  }

  void removeFamilyMember(int index) {
    if (index >= 0 && index < state.familyMembers.length) {
      final updatedMembers = List<FamilyMember>.from(state.familyMembers)
        ..removeAt(index);
      emit(state.copyWith(familyMembers: updatedMembers));
    }
  }

  void updateFamilyMember(int index, FamilyMember member) {
    if (index >= 0 && index < state.familyMembers.length) {
      final updatedMembers = List<FamilyMember>.from(state.familyMembers);
      updatedMembers[index] = member;
      emit(state.copyWith(familyMembers: updatedMembers));
    }
  }

  void clearFamilyMembers() {
    emit(state.copyWith(familyMembers: []));
  }

  Future<void> submit() async {
    emit(state.copyWith(isLoading: true, error: null));

    final formData = FormData(
      refNo: state.refNo,
      admissionNo: state.admissionNo,
      headName: '',
      // Not needed anymore
      headInitials: '',
      // Not needed anymore
      address: state.address,
      headNIC: '',
      // Not needed anymore
      headAge: '',
      // Not needed anymore
      mobile: state.mobile,
      occupation: '',
      // Not needed anymore
      headGender: '',
      // Not needed anymore
      headCivilStatus: '',
      // Not needed anymore
      ownership: state.ownership,
      zakath: state.zakath,
      familyMembers: state.familyMembers,
    );

    final result = await submitForm(formData);

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        error: failure.message,
      )),
      (_) {
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
        ));
        // Reset success flag after a brief moment
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!isClosed) {
            emit(state.copyWith(isSuccess: false));
          }
        });
      },
    );
  }

  void resetForm() {
    emit(MainFormState.initial());
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}