import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmf/core/theme/app_theme.dart';
import 'package:mmf/core/utils/date_utils.dart';
import 'package:mmf/domain/entities/family_member.dart';
import 'package:mmf/domain/entities/main_form.dart';
import 'package:mmf/domain/usecases/submit_form.dart';
import 'package:mmf/presentation/cubits/main_form_state.dart';

class MainFormCubit extends Cubit<MainFormState> {
  final SubmitForm submitForm;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ScrollController scrollController = ScrollController();

  TextEditingController addressController = TextEditingController();
  TextEditingController admissionNoController = TextEditingController();
  TextEditingController familiesCountController = TextEditingController();

  MainFormCubit({required this.submitForm}) : super(MainFormState(refNo: DateTimeUtils.generateRefNo()));

  @override
  Future<void> close() {
    addressController.dispose();
    admissionNoController.dispose();
    familiesCountController.dispose();
    scrollController.dispose();
    return super.close();
  }

  void addFamilyMember(FamilyMember member) {
    final updatedMembers = List<FamilyMember>.from(state.familyMembers)..add(member);
    emit(state.copyWith(familyMembers: updatedMembers));
  }

  void clearError() {
    emit(state.copyWith(error: null));
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

  void removeFamilyMember(int index) {
    if (index >= 0 && index < state.familyMembers.length) {
      final updatedMembers = List<FamilyMember>.from(state.familyMembers)..removeAt(index);
      emit(state.copyWith(familyMembers: updatedMembers));
    }
  }

  void resetForm() {
    addressController.clear();
    admissionNoController.clear();
    familiesCountController.clear();

    Future.delayed(const Duration(seconds: 1), () => formKey.currentState?.reset());

    emit(state.copyWith(
      isSuccess: false,
      address: '',
      admissionNo: '',
      familiesCount: '',
      ownership: '',
      refNo: DateTimeUtils.generateRefNo(),
      error: null,
      familyMembers: [],
    ));
  }

  void scrollToTop() {
    scrollController.animateTo(
      0,
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 500),
    );
    emit(state.copyWith(
      isLoading: false,
      isSuccess: true,
    ));
  }

  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.red,
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

  void showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppTheme.green3,
        behavior: SnackBarBehavior.fixed,
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 12),
            Text('Form submitted successfully.', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
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

      final status = state.familyMembers.any((m) => m.relationship == 'Head of Family');
      if (!status) {
        showErrorSnackBar(
          context,
          'Please designate one member as Head of Family.',
        );
        return;
      }

      return;
    }

    emit(state.copyWith(
      isLoading: true,
      error: null,
    ));

    final mainForm = MainForm(
      address: state.address,
      admissionNo: state.admissionNo,
      familiesCount: state.familiesCount,
      ownership: state.ownership,
      refNo: state.refNo,
      familyMembers: state.familyMembers,
    );

    final result = await submitForm(mainForm);

    result.fold((failure) => emit(state.copyWith(
        isLoading: false,
        error: failure.message,
      )), (_) {
        scrollToTop();
        resetForm();
      },
    );
  }

  void updateAddress(String value) {
    emit(state.copyWith(address: value));
  }

  void updateAdmissionNo(String value) {
    emit(state.copyWith(admissionNo: value));
  }

  void updateFamiliesCount(String value) {
    emit(state.copyWith(familiesCount: value));
  }

  void updateFamilyMember(int index, FamilyMember member) {
    if (index >= 0 && index < state.familyMembers.length) {
      final updatedMembers = List<FamilyMember>.from(state.familyMembers);
      updatedMembers[index] = member;
      emit(state.copyWith(familyMembers: updatedMembers));
    }
  }

  void updateOwnership(String value) {
    emit(state.copyWith(ownership: value));
  }

  void updateRefNo(String value) {
    emit(state.copyWith(refNo: value));
  }

  bool validateForm() {
    if (!(formKey.currentState?.validate() ?? false)) {
      return false;
    }

    if (state.familyMembers.isEmpty) {
      return false;
    }

    final status = state.familyMembers.any((m) => m.relationship == 'Head of Family');
    return status;
  }
}