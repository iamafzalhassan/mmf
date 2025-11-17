import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmf/core/theme/app_theme.dart';
import 'package:mmf/presentation/cubits/main_form_cubit.dart';
import 'package:mmf/presentation/cubits/main_form_state.dart';
import 'package:mmf/presentation/pages/family_form.dart';
import 'package:mmf/presentation/widgets/custom_dropdown.dart';
import 'package:mmf/presentation/widgets/custom_textfield.dart';
import 'package:mmf/presentation/widgets/family_card.dart';
import 'package:mmf/presentation/widgets/gradient_button.dart';
import 'package:mmf/presentation/widgets/section_header.dart';

class MahallaForm extends StatelessWidget {
  const MahallaForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: BlocConsumer<MainFormCubit, MainFormState>(
          listenWhen: (prev, curr) =>
              prev.isSuccess != curr.isSuccess || prev.error != curr.error,
          listener: (context, state) {
            final cubit = context.read<MainFormCubit>();
            if (state.isSuccess) {
              cubit.showSuccessSnackbar(context);
              cubit.resetForm();
            } else if (state.error != null) {
              cubit.showErrorSnackbar(context, state.error!);
            }
          },
          builder: (context, state) {
            final cubit = context.read<MainFormCubit>();

            return SingleChildScrollView(
              controller: cubit.scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: cubit.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 16),
                      _buildFormCard(context, state, cubit),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mahalla Members Details Collection Form',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            height: 1.25,
          ),
        ),
        Text(
          'Kohilawatta Jumma Masjid & Burial Ground',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard(
      BuildContext context, MainFormState state, MainFormCubit cubit) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHouseholdSection(state, cubit),
            const SizedBox(height: 32),
            const Divider(height: 1),
            const SizedBox(height: 32),
            _buildFamilyMembersSection(context, state, cubit),
            const SizedBox(height: 32),
            _buildSubmitButton(context, state, cubit),
          ],
        ),
      ),
    );
  }

  Widget _buildHouseholdSection(MainFormState state, MainFormCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Household Information',
          icon: Icons.home_rounded,
        ),
        const SizedBox(height: 24),
        CustomTextField(
          label: 'Reference No',
          initialValue: state.refNo,
          readOnly: true,
          suffixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
        ),
        const SizedBox(height: 20),
        CustomTextField(
          label: 'Admission (Sandapaname) No',
          initialValue: state.admissionNo,
          onChanged: cubit.updateAdmissionNo,
          hintText: 'Enter admission number',
        ),
        const SizedBox(height: 20),
        CustomTextField(
          label: 'Address',
          initialValue: state.address,
          onChanged: cubit.updateAddress,
          isRequired: true,
          hintText: 'Enter full address',
        ),
        const SizedBox(height: 20),
        CustomDropdown(
          label: 'House Ownership',
          value: state.ownership,
          items: const ['Own', 'Rent'],
          onChanged: cubit.updateOwnership,
          isRequired: true,
        ),
      ],
    );
  }

  Widget _buildFamilyMembersSection(
      BuildContext context, MainFormState state, MainFormCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Family Members',
          icon: Icons.people_rounded,
        ),
        if (state.familyMembers.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 32, bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.scaffoldBackground.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: AppTheme.secondaryColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'No family members added yet. Add at least one member as Head of Family.',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (state.familyMembers.isNotEmpty) const SizedBox(height: 32),
        ...List.generate(
          state.familyMembers.length,
          (index) {
            final member = state.familyMembers[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: FamilyMemberCard(
                index: index,
                member: member,
                onTap: () =>
                    _handleEditMember(context, cubit, state, index, member),
                onRemove: () => cubit.removeFamilyMember(index),
              ),
            );
          },
        ),
        SizedBox(
          height: 52,
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
            label: const Text('Add Family Member'),
            onPressed: () => _handleAddMember(context, cubit, state),
          ),
        ),
      ],
    );
  }

  Future<void> _handleAddMember(
      BuildContext context, MainFormCubit cubit, MainFormState state) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FamilyForm()),
    );

    if (result != null && result is Map<String, dynamic>) {
      final member = result['member'];

      if (member.relationship == 'Head of Family') {
        if (cubit.hasExistingHead()) {
          if (!context.mounted) return;
          cubit.showWarningSnackbar(
            context,
            'A Head of Family already exists. Only one Head of Family is allowed.',
          );
          return;
        }
      }

      cubit.addFamilyMember(member);
    }
  }

  Future<void> _handleEditMember(BuildContext context, MainFormCubit cubit,
      MainFormState state, int index, dynamic member) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FamilyForm(
          existingMember: member,
          memberIndex: index,
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      final updatedMember = result['member'];
      final editIndex = result['memberIndex'] as int?;

      if (updatedMember.relationship == 'Head of Family') {
        if (cubit.hasExistingHead(excludeIndex: editIndex)) {
          if (!context.mounted) return;
          cubit.showWarningSnackbar(
            context,
            'A Head of Family already exists. Please change the existing Head\'s relationship first.',
          );
          return;
        }
      }

      cubit.updateFamilyMember(index, updatedMember);
    }
  }

  Widget _buildSubmitButton(
      BuildContext context, MainFormState state, MainFormCubit cubit) {
    return GradientButton(
      text: 'Submit Form',
      icon: Icons.arrow_circle_right_rounded,
      onPressed: () => _handleSubmit(context, cubit),
      isLoading: state.isLoading,
    );
  }

  void _handleSubmit(BuildContext context, MainFormCubit cubit) {
    final state = cubit.state;
    if (!cubit.validateForm()) {
      if (state.familyMembers.isEmpty) {
        cubit.showWarningSnackbar(
          context,
          'Please add at least one family member',
        );
        return;
      }

      final hasHead =
          state.familyMembers.any((m) => m.relationship == 'Head of Family');
      if (!hasHead) {
        cubit.showWarningSnackbar(
          context,
          'Please designate one member as Head of Family',
        );
        return;
      }
    }

    cubit.submit();
  }
}