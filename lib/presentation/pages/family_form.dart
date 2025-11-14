import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmf/domain/entities/family_member.dart';
import 'package:mmf/presentation/cubits/family_member_cubit.dart';
import 'package:mmf/presentation/widgets/checkbox_grid.dart';
import 'package:mmf/presentation/widgets/custom_dropdown.dart';
import 'package:mmf/presentation/widgets/custom_textfield.dart';
import 'package:mmf/presentation/widgets/gradient_button.dart';

class FamilyForm extends StatelessWidget {
  final FamilyMember? existingMember;
  final int? memberIndex;

  const FamilyForm({
    super.key,
    this.existingMember,
    this.memberIndex,
  });

  bool get isEditing => existingMember != null;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = FamilyMemberCubit();
        if (existingMember != null) {
          cubit.loadMember(existingMember!);
        }
        return cubit;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(isEditing ? 'Edit Family Member' : 'Add Family Member'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<FamilyMemberCubit, FamilyMemberState>(
          builder: (context, state) {
            final cubit = context.read<FamilyMemberCubit>();
            final formKey = GlobalKey<FormState>();

            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      _buildPersonalInfoSection(context, state, cubit),
                      const SizedBox(height: 32),
                      _buildEducationSection(cubit, state),
                      const SizedBox(height: 16),
                      _buildMadarasaSection(cubit, state),
                      const SizedBox(height: 16),
                      _buildUlamaSection(cubit, state),
                      const SizedBox(height: 16),
                      _buildSpecialNeedsSection(cubit, state),
                      const SizedBox(height: 32),
                      _buildActionButtons(context, formKey, state),
                      const SizedBox(height: 32),
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

  Widget _buildPersonalInfoSection(
      BuildContext context, FamilyMemberState state, FamilyMemberCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: 'Full Name',
          initialValue: state.name,
          onChanged: cubit.updateName,
          isRequired: true,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'National ID No',
                initialValue: state.nic,
                onChanged: cubit.updateNic,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                label: 'Age',
                initialValue: state.age,
                onChanged: cubit.updateAge,
                isRequired: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomDropdown(
                label: 'Gender',
                value: state.gender,
                items: const ['Male', 'Female'],
                onChanged: cubit.updateGender,
                isRequired: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomDropdown(
                label: 'Civil Status',
                value: state.civilStatus,
                items: const ['Married', 'Single', 'Divorced', 'Widow'],
                onChanged: cubit.updateCivilStatus,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomDropdown(
          label: 'Relationship to Head',
          value: state.relationship,
          items: const [
            'Head of Family',
            'Spouse',
            'Son',
            'Daughter',
            'Father',
            'Mother',
            'Brother',
            'Sister',
            'Grandson',
            'Granddaughter',
            'Other'
          ],
          onChanged: cubit.updateRelationship,
          isRequired: true,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Occupation/Business',
          initialValue: state.occupation,
          onChanged: cubit.updateOccupation,
          isRequired: true,
        ),
        const SizedBox(height: 16),
        CustomDropdown(
          label: 'Status',
          value: state.status,
          items: const [
            'Studying Only',
            'Working Only',
            'Studying and Working',
            'Not Working/Studying'
          ],
          onChanged: cubit.updateStatus,
        ),
      ],
    );
  }

  Widget _buildEducationSection(
      FamilyMemberCubit cubit, FamilyMemberState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.school, color: Color(0xFF667EEA)),
              SizedBox(width: 8),
              Text(
                'Education & Qualifications',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF667EEA),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CheckboxGrid(
            items: const [
              'Above Grade 5',
              'O/L',
              'A/L',
              'Certificate',
              'Diploma',
              'Degree',
              "Master's Degree",
              'Phd',
            ],
            selectedItems: state.students,
            onChanged: cubit.toggleStudent,
          ),
        ],
      ),
    );
  }

  Widget _buildMadarasaSection(
      FamilyMemberCubit cubit, FamilyMemberState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.menu_book, color: Color(0xFF667EEA)),
              SizedBox(width: 8),
              Text(
                'Madarasa Education',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF667EEA),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CheckboxGrid(
            items: const [
              'Kitab Part Time',
              'Kitab Full Time',
              'Hifz Part Time',
              'Hifz Full Time',
            ],
            selectedItems: state.madarasa,
            onChanged: cubit.toggleMadarasa,
          ),
        ],
      ),
    );
  }

  Widget _buildUlamaSection(FamilyMemberCubit cubit, FamilyMemberState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_stories, color: Color(0xFF667EEA)),
              SizedBox(width: 8),
              Text(
                'Ulama Qualifications',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF667EEA),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CheckboxGrid(
            items: const [
              'Hafiz',
              'Hafiza',
              'Alim',
              'Alima',
              'Hafiz & Alim',
              'Hafiza & Alima'
            ],
            selectedItems: state.ulma,
            onChanged: cubit.toggleUlma,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialNeedsSection(
      FamilyMemberCubit cubit, FamilyMemberState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.favorite, color: Color(0xFF667EEA)),
              SizedBox(width: 8),
              Text(
                'Special Needs',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF667EEA),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CheckboxGrid(
            items: const ['Disabled', 'Medical Support', 'Education Support'],
            selectedItems: state.specialNeeds,
            onChanged: cubit.toggleSpecialNeeds,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, GlobalKey<FormState> formKey, FamilyMemberState state) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GradientButton(
            text: isEditing ? 'Update Member' : 'Save Member',
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                final member = state.toEntity();
                Navigator.pop(context, member);
              }
            },
          ),
        ),
      ],
    );
  }
}