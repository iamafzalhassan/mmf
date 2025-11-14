import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmf/core/theme/app_theme.dart';
import 'package:mmf/presentation/cubits/main_form_cubit.dart';
import 'package:mmf/presentation/cubits/main_form_state.dart';
import 'package:mmf/presentation/pages/family_form.dart';
import 'package:mmf/presentation/widgets/custom_dropdown.dart';
import 'package:mmf/presentation/widgets/custom_textfield.dart';
import 'package:mmf/presentation/widgets/gradient_button.dart';
import 'package:mmf/presentation/widgets/section_header.dart';

class MahallaForm extends StatelessWidget {
  const MahallaForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final scrollController = ScrollController();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: BlocConsumer<MainFormCubit, MainFormState>(
          listenWhen: (prev, curr) =>
              prev.isSuccess != curr.isSuccess || prev.error != curr.error,
          listener: (context, state) {
            if (state.isSuccess) {
              scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
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
              context.read<MainFormCubit>().resetForm();
            } else if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(child: Text(state.error!)),
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
          },
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 16),
                        _buildFormCard(context, state, formKey),
                      ],
                    ),
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
            height: 1.25
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
      BuildContext context, MainFormState state, GlobalKey<FormState> formKey) {
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
            _buildHouseholdSection(context, state),
            const SizedBox(height: 32),
            const Divider(height: 1),
            const SizedBox(height: 32),
            _buildFamilyMembersSection(context, state),
            const SizedBox(height: 32),
            const Divider(height: 1),
            const SizedBox(height: 32),
            _buildAdditionalInformationSection(context, state),
            const SizedBox(height: 32),
            _buildSubmitButton(context, formKey, state),
          ],
        ),
      ),
    );
  }

  Widget _buildHouseholdSection(BuildContext context, MainFormState state) {
    final cubit = context.read<MainFormCubit>();

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
          suffixIcon: const Icon(Icons.lock_outline, size: 20),
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
        CustomTextField(
          label: 'Mobile No',
          initialValue: state.mobile,
          onChanged: cubit.updateMobile,
          isRequired: true,
          keyboardType: TextInputType.phone,
          hintText: 'Enter phone number',
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: (val) {
            if (val?.isEmpty ?? true) return 'This field is required';
            if (val!.length != 10 || !val.startsWith('07')) {
              return 'Invalid mobile number';
            }
            return null;
          },
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

  Widget _buildFamilyMembersSection(BuildContext context, MainFormState state) {
    final cubit = context.read<MainFormCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Family Members',
          icon: Icons.people_rounded,
        ),
        const SizedBox(height: 16),
        if (state.familyMembers.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.scaffoldBackground.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    color: AppTheme.textSecondary, size: 20),
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
        if (state.familyMembers.isNotEmpty) const SizedBox(height: 16),
        ...List.generate(
          state.familyMembers.length,
          (index) {
            final member = state.familyMembers[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FamilyMemberCard(
                index: index,
                member: member,
                onTap: () async {
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
                    final isEditing = result['isEditing'] as bool;
                    final editIndex = result['memberIndex'] as int?;

                    if (updatedMember.relationship == 'Head of Family') {
                      final existingHeadIndex = state.familyMembers.indexWhere(
                          (m) =>
                              m.relationship == 'Head of Family' &&
                              (!isEditing ||
                                  state.familyMembers.indexOf(m) != editIndex));

                      if (existingHeadIndex != -1) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                                'A Head of Family already exists. Please change the existing Head\'s relationship first.'),
                            backgroundColor: AppTheme.warningColor,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                        return;
                      }
                    }

                    cubit.updateFamilyMember(index, updatedMember);
                  }
                },
                onRemove: () => cubit.removeFamilyMember(index),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 52,
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.add_rounded, size: 20),
            label: const Text('Add Family Member'),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FamilyForm(),
                ),
              );

              if (result != null && result is Map<String, dynamic>) {
                final member = result['member'];

                if (member.relationship == 'Head of Family') {
                  final hasExistingHead = state.familyMembers
                      .any((m) => m.relationship == 'Head of Family');

                  if (hasExistingHead) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                            'A Head of Family already exists. Only one Head of Family is allowed.'),
                        backgroundColor: AppTheme.warningColor,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                    return;
                  }
                }

                cubit.addFamilyMember(member);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInformationSection(
      BuildContext context, MainFormState state) {
    final cubit = context.read<MainFormCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Additional Information',
          icon: Icons.info_rounded,
        ),
        const SizedBox(height: 24),
        CustomDropdown(
          label: 'Eligible For Zakath',
          value: state.zakath,
          items: const ['Yes', 'No'],
          onChanged: cubit.updateZakath,
          isRequired: true,
        ),
      ],
    );
  }

  Widget _buildSubmitButton(
      BuildContext context, GlobalKey<FormState> formKey, MainFormState state) {
    final cubit = context.read<MainFormCubit>();

    return GradientButton(
      text: 'Submit Form',
      icon: Icons.arrow_forward_rounded,
      onPressed: () {
        if (formKey.currentState?.validate() ?? false) {
          if (state.familyMembers.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Please add at least one family member'),
                backgroundColor: AppTheme.warningColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
            return;
          }

          final hasHead = state.familyMembers
              .any((m) => m.relationship == 'Head of Family');
          if (!hasHead) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    const Text('Please designate one member as Head of Family'),
                backgroundColor: AppTheme.warningColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
            return;
          }

          cubit.submit();
        }
      },
      isLoading: state.isLoading,
    );
  }
}

class FamilyMemberCard extends StatelessWidget {
  final int index;
  final dynamic member;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const FamilyMemberCard({
    super.key,
    required this.index,
    required this.member,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isHead = member.relationship == 'Head of Family';

    return Container(
      decoration: BoxDecoration(
        color: isHead
            ? AppTheme.primaryColor.withOpacity(0.05)
            : AppTheme.scaffoldBackground.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHead ? AppTheme.primaryColor : AppTheme.borderColor,
          width: isHead ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isHead
                        ? AppTheme.primaryColor.withOpacity(0.15)
                        : AppTheme.checkboxUnselectedBackground,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    isHead ? Icons.star_rounded : Icons.person_rounded,
                    color:
                        isHead ? AppTheme.primaryColor : AppTheme.iconSecondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name.isNotEmpty ? member.name : 'Unnamed Member',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        member.relationship.isNotEmpty
                            ? member.relationship
                            : 'No relationship set',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded),
                  color: AppTheme.errorColor,
                  onPressed: onRemove,
                  tooltip: 'Remove member',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}