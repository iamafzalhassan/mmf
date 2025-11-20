import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmf/core/theme/app_theme.dart';
import 'package:mmf/core/utils/date_utils.dart';
import 'package:mmf/domain/entities/family_member.dart';
import 'package:mmf/domain/entities/form_data.dart';
import 'package:mmf/domain/usecases/submit_form.dart';
import 'package:mmf/presentation/cubits/main_form_state.dart';

class MainFormCubit extends Cubit<MainFormState> {
  final SubmitForm submitForm;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();
  final TextEditingController admissionNoController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController familiesCountController = TextEditingController();

  MainFormCubit({required this.submitForm})
      : super(MainFormState(refNo: DateTimeUtils.generateRefNo()));

  void updateRefNo(String value) {
    emit(state.copyWith(refNo: value));
  }

  void updateAdmissionNo(String value) {
    emit(state.copyWith(admissionNo: value));
  }

  void updateAddress(String value) {
    emit(state.copyWith(address: value));
  }

  void updateOwnership(String value) {
    emit(state.copyWith(ownership: value));
  }

  void updateFamiliesCount(String value) {
    emit(state.copyWith(familiesCount: value));
  }

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

    final status =
        state.familyMembers.any((m) => m.relationship == 'Head of Family');
    return status;
  }

  Future<void> submit(BuildContext context) async {
    if (!validateForm()) {
      if (state.familyMembers.isEmpty) {
        showErrorSnackBar(
          context,
          'Please add at least one family member.',
        );
        return;
      }

      final status =
          state.familyMembers.any((m) => m.relationship == 'Head of Family');
      if (!status) {
        showErrorSnackBar(
          context,
          'Please designate one member as Head of Family.',
        );
        return;
      }

      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    final formData = FormData(
      refNo: state.refNo,
      admissionNo: state.admissionNo,
      address: state.address,
      ownership: state.ownership,
      familiesCount: state.familiesCount,
      // New field
      familyMembers: state.familyMembers,
    );

    final result = await submitForm(formData);

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        error: failure.message,
      )),
      (_) {
        scrollToTop();
        resetForm();
      },
    );
  }

  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    emit(state.copyWith(
      isLoading: false,
      isSuccess: true,
    ));
  }

  void showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.fixed,
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 12),
            Text('Form submitted successfully.',
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.fixed,
        content: Row(
          children: [
            const Icon(Icons.info_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Text(message, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  void resetForm() {
    admissionNoController.clear();
    addressController.clear();
    familiesCountController.clear();

    Future.delayed(
        const Duration(seconds: 1), () => formKey.currentState?.reset());

    emit(state.copyWith(
      refNo: DateTimeUtils.generateRefNo(),
      admissionNo: '',
      address: '',
      ownership: '',
      familiesCount: '',
      familyMembers: [],
      isSuccess: false,
      error: null,
    ));
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }

  @override
  Future<void> close() {
    admissionNoController.dispose();
    addressController.dispose();
    familiesCountController.dispose();
    scrollController.dispose();
    return super.close();
  }
}