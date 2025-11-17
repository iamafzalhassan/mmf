import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmf/core/theme/app_theme.dart';
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
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          child: BlocBuilder<FamilyMemberCubit, FamilyMemberState>(
            builder: (context, state) {
              final cubit = context.read<FamilyMemberCubit>();

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildHeader(context),
                      Form(
                        key: cubit.formKey,
                        child: Container(
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
                                _buildPersonalInfoSection(cubit, state),
                                const SizedBox(height: 32),
                                const Divider(height: 1),
                                const SizedBox(height: 32),
                                _buildSchoolEducationSection(cubit, state),
                                const SizedBox(height: 24),
                                _buildProfessionalQualificationsSection(
                                    cubit, state),
                                const SizedBox(height: 24),
                                _buildMadarasaEducationSection(cubit, state),
                                const SizedBox(height: 24),
                                _buildUlamaQualificationsSection(cubit, state),
                                const SizedBox(height: 24),
                                _buildSpecialNeedsSection(cubit, state),
                                const SizedBox(height: 32),
                                const Divider(height: 1),
                                const SizedBox(height: 32),
                                _buildAdditionalInfoSection(cubit, state),
                                const SizedBox(height: 32),
                                _buildActionButtons(context, cubit, state),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(12),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 20,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Edit Member' : 'Add Member',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    height: 1.25,
                  ),
                ),
                Text(
                  'Family member details',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection(
      FamilyMemberCubit cubit, FamilyMemberState state) {
    final isHeadOfFamily = state.relationship == 'Head of Family';
    final shouldShowOccupation = state.status == 'Working Only' ||
        state.status == 'Studying and Working';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.person_rounded, color: AppTheme.primaryColor, size: 24),
            SizedBox(width: 12),
            Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        CustomTextField(
          label: 'Full Name',
          controller: cubit.nameController,
          onChanged: cubit.updateName,
          isRequired: true,
          hintText: 'Enter full name',
        ),
        const SizedBox(height: 20),
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
              child: CustomTextField(
                label: 'Age',
                controller: cubit.ageController,
                onChanged: cubit.updateAge,
                isRequired: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                hintText: 'Enter age',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        CustomTextField(
          label: 'Mobile No',
          controller: cubit.mobileController,
          onChanged: cubit.updateMobile,
          isRequired: isHeadOfFamily,
          keyboardType: TextInputType.phone,
          hintText: 'Enter phone number',
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: (val) {
            if (isHeadOfFamily) {
              if (val?.isEmpty ?? true) {
                return 'Mobile number is required for Head of Family';
              }
              if (val!.length != 10 || !val.startsWith('07')) {
                return 'Invalid mobile number';
              }
            } else if (val != null && val.isNotEmpty) {
              if (val.length != 10 || !val.startsWith('07')) {
                return 'Invalid mobile number';
              }
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        CustomTextField(
          label: 'National ID No',
          controller: cubit.nicController,
          onChanged: cubit.updateNic,
          hintText: 'Enter NIC',
        ),
        const SizedBox(height: 20),
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
        const SizedBox(height: 20),
        if (shouldShowOccupation)
          CustomTextField(
            label: 'Occupation/Business',
            controller: cubit.occupationController,
            onChanged: cubit.updateOccupation,
            isRequired: true,
            hintText: 'Enter occupation',
          ),
        if (shouldShowOccupation) const SizedBox(height: 20),
        CustomDropdown(
          label: 'Civil Status',
          value: state.civilStatus,
          items: const ['Married', 'Single', 'Divorced', 'Widow'],
          onChanged: cubit.updateCivilStatus,
        ),
        const SizedBox(height: 20),
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
      ],
    );
  }

  Widget _buildSchoolEducationSection(
      FamilyMemberCubit cubit, FamilyMemberState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.scaffoldBackground.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.local_library_rounded,
                  color: AppTheme.primaryColor, size: 22),
              SizedBox(width: 10),
              Text(
                'School Education',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CheckboxGrid(
            items: const [
              'Above Grade 5',
              'O/L',
              'A/L',
            ],
            selectedItems: state.schoolEducation,
            onChanged: cubit.toggleSchoolEducation,
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalQualificationsSection(
      FamilyMemberCubit cubit, FamilyMemberState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.scaffoldBackground.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.school_rounded,
                  color: AppTheme.primaryColor, size: 22),
              SizedBox(width: 10),
              Text(
                'Professional Qualifications',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CheckboxGrid(
            items: const [
              'Certificate',
              'Diploma',
              'Degree',
              "Master's Degree",
              'Phd',
            ],
            selectedItems: state.professionalQualifications,
            onChanged: cubit.toggleProfessionalQualification,
          ),
        ],
      ),
    );
  }

  Widget _buildMadarasaEducationSection(
      FamilyMemberCubit cubit, FamilyMemberState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.scaffoldBackground.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.local_library_rounded,
                  color: AppTheme.primaryColor, size: 22),
              SizedBox(width: 10),
              Text(
                'Madarasa Education',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
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

  Widget _buildUlamaQualificationsSection(
      FamilyMemberCubit cubit, FamilyMemberState state) {
    final List<String> ulamaItems;
    if (state.gender == 'Female') {
      ulamaItems = const ['Hafiza', 'Alima'];
    } else if (state.gender == 'Male') {
      ulamaItems = const ['Hafiz', 'Alim'];
    } else {
      ulamaItems = const ['Hafiz', 'Hafiza', 'Alim', 'Alima'];
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.scaffoldBackground.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.school_rounded,
                  color: AppTheme.primaryColor, size: 22),
              SizedBox(width: 10),
              Text(
                'Ulama Qualifications',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CheckboxGrid(
            items: ulamaItems,
            selectedItems: state.ulama,
            onChanged: cubit.toggleUlama,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialNeedsSection(
      FamilyMemberCubit cubit, FamilyMemberState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.scaffoldBackground.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.favorite_rounded,
                  color: AppTheme.primaryColor, size: 22),
              SizedBox(width: 10),
              Text(
                'Special Needs',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CheckboxGrid(
            items: const ['Disabled', 'Medical Support', 'Education Support'],
            selectedItems: state.specialNeeds,
            onChanged: cubit.toggleSpecialNeeds,
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoSection(
      FamilyMemberCubit cubit, FamilyMemberState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.info_rounded, color: AppTheme.primaryColor, size: 24),
            SizedBox(width: 12),
            Text(
              'Additional Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
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

  Widget _buildActionButtons(
      BuildContext context, FamilyMemberCubit cubit, FamilyMemberState state) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 52,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(fontSize: 16)),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GradientButton(
            text: isEditing ? 'Update' : 'Save',
            icon: Icons.check_circle_rounded,
            onPressed: () {
              if (cubit.validateAndSave()) {
                final member = state.toEntity();
                Navigator.pop(context, {
                  'member': member,
                  'isEditing': isEditing,
                  'memberIndex': memberIndex,
                });
              }
            },
          ),
        ),
      ],
    );
  }
}