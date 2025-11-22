import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          listenWhen: (prev, curr) => prev.isSuccess != curr.isSuccess || prev.error != curr.error,
          listener: (context, state) {
            final cubit = context.read<MainFormCubit>();
            if (state.isSuccess) {
              cubit.showSuccessSnackBar(context);
            } else if (state.error != null) {
              cubit.showErrorSnackBar(context, state.error!);
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
                      buildHeader(),
                      const SizedBox(height: 16),
                      buildFormCard(context, state, cubit),
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

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Text(
                'Mahalla Members Details Collection Form 2025',
                style: TextStyle(
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 1.25
                    ..color = AppTheme.black,
                  fontSize: 32,
                  height: 1,
                ),
              ),
              const Text(
                'Mahalla Members Details Collection Form 2025',
                style: TextStyle(color: AppTheme.black, fontSize: 32, height: 1),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Kohilawatta JM & Burial Ground',
            style: TextStyle(color: AppTheme.gray5, fontSize: 22, height: 1),
          ),
        ],
      ),
    );
  }

  Widget buildFormCard(BuildContext context, MainFormState state, MainFormCubit cubit) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 24,
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 8),
          ),
        ],
        color: AppTheme.white1,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHouseholdSection(state, cubit),
            const SizedBox(height: 32),
            const Divider(height: 1),
            const SizedBox(height: 32),
            buildFamilyMembersSection(context, cubit, state),
            const SizedBox(height: 32),
            GradientButton(
              icon: Icons.arrow_circle_right_rounded,
              isLoading: state.isLoading,
              onPressed: () => cubit.submit(context),
              text: 'Submit Form',
            )
          ],
        ),
      ),
    );
  }

  Widget buildHouseholdSection(MainFormState state, MainFormCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          icon: Icons.home_rounded,
          title: 'Household Information',
        ),
        const SizedBox(height: 24),
        CustomTextField(
          initialValue: state.refNo,
          label: 'Reference No',
          readOnly: true,
          suffixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: cubit.admissionNoController,
          hintText: 'Enter admission number',
          label: 'Admission (Sandapaname) No',
          onChanged: cubit.updateAdmissionNo,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: cubit.addressController,
          hintText: 'Enter full address',
          isRequired: true,
          label: 'Address',
          onChanged: cubit.updateAddress,
        ),
        const SizedBox(height: 20),
        CustomDropdown(
          isRequired: true,
          items: const ['Own', 'Rent'],
          label: 'House Ownership',
          onChanged: cubit.updateOwnership,
          value: state.ownership,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: cubit.familiesCountController,
          hintText: 'Enter number of families',
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2),
          ],
          isRequired: true,
          keyboardType: TextInputType.number,
          label: 'Families in Home',
          onChanged: cubit.updateFamiliesCount,
          validator: (val) {
            if (val?.isEmpty ?? true) {
              return 'This field is required';
            }
            final num = int.tryParse(val!);
            if (num == null || num < 1) {
              return 'Please enter a valid number (min 1)';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget buildFamilyMembersSection(BuildContext context, MainFormCubit cubit, MainFormState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          icon: Icons.people_rounded,
          title: 'Family Members',
        ),
        if (state.familyMembers.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 16, top: 32),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppTheme.green1,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Required to add at least one member as Head of Family.',
                    style: TextStyle(
                      color: AppTheme.gray5,
                      fontSize: 16,
                      height: 1.25,
                    ),
                  ),
                ),
              ],
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
                onRemove: () => cubit.removeFamilyMember(index),
                onTap: () => editMember(context, cubit, state, index, member),
              ),
            );
          },
        ),
        SizedBox(
          height: 52,
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
            label: const Text('Add Family Member', style: TextStyle(fontSize: 18)),
            onPressed: () => addMember(context, cubit, state),
            style: ButtonStyle(
              minimumSize: WidgetStateProperty.all<Size>(const Size(0, 0)),
              padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.all(0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> addMember(BuildContext context, MainFormCubit cubit, MainFormState state) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FamilyForm()),
    );

    if (result != null && result is Map<String, dynamic>) {
      final member = result['member'];

      if (member.relationship == 'Head of Family') {
        if (cubit.hasExistingHead()) {
          if (!context.mounted) return;

          cubit.showErrorSnackBar(
            context,
            'A Head of Family already exists. Only one Head of Family is allowed.',
          );
          return;
        }
      }

      cubit.addFamilyMember(member);
    }
  }

  Future<void> editMember(BuildContext context, MainFormCubit cubit, MainFormState state, int index, dynamic member) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FamilyForm(existingMember: member, memberIndex: index)),
    );

    if (result != null && result is Map<String, dynamic>) {
      final editIndex = result['memberIndex'] as int?;
      final updatedMember = result['member'];

      if (updatedMember.relationship == 'Head of Family') {
        if (cubit.hasExistingHead(excludeIndex: editIndex)) {
          if (!context.mounted) return;

          cubit.showErrorSnackBar(
            context,
            'A Head of Family already exists. Please change the existing Head\'s relationship first.',
          );
          return;
        }
      }

      cubit.updateFamilyMember(index, updatedMember);
    }
  }
}