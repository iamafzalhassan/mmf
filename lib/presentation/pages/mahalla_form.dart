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
      backgroundColor: AppTheme.scaffoldBackground,
      body: BlocConsumer<MainFormCubit, MainFormState>(
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
              const SnackBar(
                content: Text('Form submitted successfully!'),
                backgroundColor: AppTheme.successColor,
              ),
            );
            context.read<MainFormCubit>().resetForm();
          } else if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          _buildHouseholdSection(context, state),
                          _buildFamilyMembersSection(context, state),
                          _buildAdditionalInformationSection(context, state),
                          const SizedBox(height: 16),
                          _buildSubmitButton(context, formKey, state),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Mahalla Members Details Collection Form',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          'Kohilawatta Jumma Masjid & Burial Ground',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildHouseholdSection(BuildContext context, MainFormState state) {
    final cubit = context.read<MainFormCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        const SectionHeader(
          title: 'Household Information',
          icon: Icons.home_filled,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Reference No',
          initialValue: state.refNo,
          readOnly: true,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Admission (Sandapaname) No',
          initialValue: state.admissionNo,
          onChanged: cubit.updateAdmissionNo,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Address',
          initialValue: state.address,
          onChanged: cubit.updateAddress,
          isRequired: true,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Mobile No',
          initialValue: state.mobile,
          onChanged: cubit.updateMobile,
          isRequired: true,
          keyboardType: TextInputType.phone,
          hintText: '07XXXXXXXX',
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: (val) {
            if (val?.isEmpty ?? true) return 'Required';
            if (val!.length != 10 || !val.startsWith('07')) {
              return 'Invalid mobile number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
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
        const SizedBox(height: 32),
        const SectionHeader(
          title: 'Family Members',
          icon: Icons.family_restroom,
        ),
        if (state.familyMembers.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'No family members added yet. Please add at least one member as Head of Family.',
              style: TextStyle(
                  color: AppTheme.textSecondary, fontStyle: FontStyle.italic),
            ),
          ),
        if (state.familyMembers.isNotEmpty) const SizedBox(height: 16),
        ...List.generate(
          state.familyMembers.length,
          (index) {
            final member = state.familyMembers[index];
            return FamilyMemberCard(
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

                  // Check if trying to set as Head of Family
                  if (updatedMember.relationship == 'Head of Family') {
                    // Find if there's already a head (excluding current member if editing)
                    final existingHeadIndex = state.familyMembers.indexWhere(
                        (m) =>
                            m.relationship == 'Head of Family' &&
                            (!isEditing ||
                                state.familyMembers.indexOf(m) != editIndex));

                    if (existingHeadIndex != -1) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'A Head of Family already exists. Please change the existing Head\'s relationship first.'),
                          backgroundColor: AppTheme.warningColor,
                          duration: Duration(seconds: 3),
                        ),
                      );
                      return;
                    }
                  }

                  cubit.updateFamilyMember(index, updatedMember);
                }
              },
              onRemove: () => cubit.removeFamilyMember(index),
            );
          },
        ),
        SizedBox(
          height: 48,
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child:
                const Text('Add Family Member', style: TextStyle(fontSize: 16)),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FamilyForm(),
                ),
              );

              if (result != null && result is Map<String, dynamic>) {
                final member = result['member'];

                // Check if trying to add as Head of Family
                if (member.relationship == 'Head of Family') {
                  final hasExistingHead = state.familyMembers
                      .any((m) => m.relationship == 'Head of Family');

                  if (hasExistingHead) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'A Head of Family already exists. Only one Head of Family is allowed.'),
                        backgroundColor: AppTheme.warningColor,
                        duration: Duration(seconds: 3),
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
        const SizedBox(height: 32),
        const SectionHeader(
          title: 'Additional Information',
          icon: Icons.info,
        ),
        const SizedBox(height: 16),
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
      onPressed: () {
        if (formKey.currentState?.validate() ?? false) {
          if (state.familyMembers.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please add at least one family member'),
                backgroundColor: AppTheme.warningColor,
              ),
            );
            return;
          }

          // Check if there's a Head of Family
          final hasHead = state.familyMembers
              .any((m) => m.relationship == 'Head of Family');
          if (!hasHead) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please designate one member as Head of Family'),
                backgroundColor: AppTheme.warningColor,
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
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppTheme.cardBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: member.relationship == 'Head of Family'
              ? Theme.of(context).colorScheme.primary
              : AppTheme.borderColor,
          width: member.relationship == 'Head of Family' ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: member.relationship == 'Head of Family'
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                      : AppTheme.checkboxUnselectedBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  member.relationship == 'Head of Family'
                      ? Icons.star
                      : Icons.person,
                  color: member.relationship == 'Head of Family'
                      ? Theme.of(context).colorScheme.primary
                      : AppTheme.iconSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name.isNotEmpty ? member.name : 'Unnamed Member',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
                icon: const Icon(Icons.delete, color: AppTheme.errorColor),
                onPressed: onRemove,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
