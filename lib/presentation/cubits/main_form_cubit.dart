import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmf/core/theme/app_theme.dart';
import 'package:mmf/domain/entities/family_member.dart';
import 'package:mmf/domain/entities/form_data.dart';
import 'package:mmf/domain/usecases/submit_form.dart';
import 'package:mmf/presentation/cubits/main_form_state.dart';

class MainFormCubit extends Cubit<MainFormState> {
  final SubmitForm submitForm;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();

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

  bool hasExistingHead({int? excludeIndex}) {
    return state.familyMembers.asMap().entries.any((entry) {
      if (excludeIndex != null && entry.key == excludeIndex) {
        return false;
      }
      return entry.value.relationship == 'Head of Family';
    });
  }

  bool validateForm() {
    if (!(formKey.currentState?.validate() ?? false)) {
      return false;
    }

    if (state.familyMembers.isEmpty) {
      return false;
    }

    final hasHead = state.familyMembers.any((m) => m.relationship == 'Head of Family');
    return hasHead;
  }

  Future<void> submit() async {
    emit(state.copyWith(isLoading: true, error: null));

    final formData = FormData(
      refNo: state.refNo,
      admissionNo: state.admissionNo,
      address: state.address,
      mobile: state.mobile,
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
        // Reset the form completely after success
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!isClosed) {
            scrollToTop();
            emit(MainFormState.initial());
          }
        });
      },
    );
  }

  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void showSuccessSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Form submitted successfully!'),
          ],
        ),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void showWarningSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.warningColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void resetForm() {
    emit(MainFormState.initial());
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }
}