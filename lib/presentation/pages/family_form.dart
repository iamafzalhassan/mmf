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
  final int? memberIndex;
  final FamilyMember? existingMember;

  const FamilyForm({
    super.key,
    this.memberIndex,
    this.existingMember,
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
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 24,
                                color: Colors.black.withOpacity(0.08),
                                offset: const Offset(0, 8),
                              ),
                            ],
                            color: AppTheme.cardBackground,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildPersonalInfoSection(
                                  cubit,
                                  state,
                                ),
                                const SizedBox(height: 32),
                                const Divider(height: 1),
                                const SizedBox(height: 32),
                                _buildSchoolEducationSection(
                                  cubit,
                                  state,
                                ),
                                const SizedBox(height: 24),
                                _buildProfessionalQualificationsSection(
                                  cubit,
                                  state,
                                ),
                                const SizedBox(height: 24),
                                _buildMadarasaEducationSection(
                                  cubit,
                                  state,
                                ),
                                const SizedBox(height: 24),
                                _buildUlamaQualificationsSection(
                                  cubit,
                                  state,
                                ),
                                const SizedBox(height: 24),
                                _buildSpecialNeedsSection(
                                  cubit,
                                  state,
                                ),
                                const SizedBox(height: 32),
                                _buildActionButtons(
                                  context,
                                  cubit,
                                  state,
                                ),
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
      padding: const EdgeInsets.only(top: 16, bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 2),
                ),
              ],
              color: AppTheme.cardBackground,
            ),
            height: 40,
            width: 40,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.pop(context),
                child: const Center(
                  child: Icon(
                    color: AppTheme.textPrimary,
                    Icons.arrow_back_rounded,
                    size: 20,
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
                Stack(
                  children: [
                    Text(
                      isEditing ? 'Edit Family Member' : 'Add Family Member',
                      style: TextStyle(
                        fontSize: 32,
                        foreground: Paint()
                          ..color = AppTheme.textPrimary
                          ..strokeWidth = 1.25
                          ..style = PaintingStyle.stroke,
                        height: 1,
                      ),
                    ),
                    Text(
                      isEditing ? 'Edit Family Member' : 'Add Family Member',
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 32,
                        height: 1,
                      ),
                    ),
                  ],
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              color: AppTheme.primaryColor,
              Icons.person_rounded,
              size: 24,
            ),
            SizedBox(width: 12),
            Text(
              'Personal Information',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        CustomTextField(
          controller: cubit.nameController,
          hintText: 'Enter full name',
          isRequired: true,
          label: 'Full Name',
          onChanged: cubit.updateName,
        ),
        const SizedBox(height: 20),
        CustomDropdown(
          isRequired: true,
          items: const ['Male', 'Female'],
          label: 'Gender',
          onChanged: cubit.updateGender,
          value: state.gender,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: cubit.ageController,
          hintText: 'Enter age',
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          isRequired: true,
          keyboardType: TextInputType.number,
          label: 'Age',
          onChanged: cubit.updateAge,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: cubit.mobileController,
          hintText: 'Enter phone number',
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          isRequired: isHeadOfFamily,
          keyboardType: TextInputType.phone,
          label: 'Mobile No',
          onChanged: cubit.updateMobile,
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
          controller: cubit.nicController,
          hintText: 'Enter NIC',
          label: 'National ID No',
          onChanged: cubit.updateNic,
        ),
        const SizedBox(height: 20),
        CustomDropdown(
          isRequired: true,
          items: const [
            'Studying Only',
            'Working Only',
            'Studying and Working',
            'Not Working/Studying'
          ],
          label: 'Status',
          onChanged: cubit.updateStatus,
          value: state.status,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: cubit.occupationController,
          hintText: 'Enter current Course, Occupation or Business',
          isRequired: true,
          label: 'Course/Occupation/Business',
          onChanged: cubit.updateOccupation,
        ),
        const SizedBox(height: 20),
        CustomDropdown(
          isRequired: true,
          items: const ['Married', 'Single', 'Divorced', 'Widow'],
          label: 'Civil Status',
          onChanged: cubit.updateCivilStatus,
          value: state.civilStatus,
        ),
        const SizedBox(height: 20),
        CustomDropdown(
          isRequired: true,
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
          label: 'Relationship to Head',
          onChanged: cubit.updateRelationship,
          value: state.relationship,
        ),
      ],
    );
  }

  Widget _buildSchoolEducationSection(
      FamilyMemberCubit cubit, FamilyMemberState state) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderColor),
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.scaffoldBackground.withOpacity(0.3),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                color: AppTheme.primaryColor,
                Icons.local_library_rounded,
                size: 22,
              ),
              SizedBox(width: 10),
              Text(
                'School Education',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CheckboxGrid(
            items: const [
              'Primary',
              'Above Grade 8',
              'O/L',
              'A/L',
            ],
            onChanged: cubit.toggleSchoolEducation,
            selectedItems: state.schoolEducation,
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalQualificationsSection(
      FamilyMemberCubit cubit, FamilyMemberState state) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderColor),
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.scaffoldBackground.withOpacity(0.3),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                color: AppTheme.primaryColor,
                Icons.school_rounded,
                size: 22,
              ),
              SizedBox(width: 10),
              Text(
                'Professional Qualifications',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
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
            onChanged: cubit.toggleProfessionalQualification,
            selectedItems: state.professionalQualifications,
          ),
        ],
      ),
    );
  }

  Widget _buildMadarasaEducationSection(
      FamilyMemberCubit cubit, FamilyMemberState state) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderColor),
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.scaffoldBackground.withOpacity(0.3),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                color: AppTheme.primaryColor,
                Icons.local_library_rounded,
                size: 22,
              ),
              SizedBox(width: 10),
              Text(
                'Madarasa Education',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
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
            onChanged: cubit.toggleMadarasa,
            selectedItems: state.madarasa,
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
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderColor),
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.scaffoldBackground.withOpacity(0.3),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                color: AppTheme.primaryColor,
                Icons.school_rounded,
                size: 22,
              ),
              SizedBox(width: 10),
              Text(
                'Ulama Qualifications',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CheckboxGrid(
            items: ulamaItems,
            onChanged: cubit.toggleUlama,
            selectedItems: state.ulama,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialNeedsSection(
      FamilyMemberCubit cubit, FamilyMemberState state) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderColor),
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.scaffoldBackground.withOpacity(0.3),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                color: AppTheme.primaryColor,
                Icons.favorite_rounded,
                size: 22,
              ),
              SizedBox(width: 10),
              Text(
                'Special Needs',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CheckboxGrid(
            items: const ['Disabled', 'Medical Support', 'Education Support', 'Converted'],
            onChanged: cubit.toggleSpecialNeeds,
            selectedItems: state.specialNeeds,
          ),
        ],
      ),
    );
  }

  /* Additional Information */
  // Widget buildAdditionalInfoSection(FamilyMemberCubit cubit, FamilyMemberState state) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Row(
  //         children: [
  //           Icon(Icons.info_rounded, color: AppTheme.primaryColor, size: 24),
  //           SizedBox(width: 12),
  //           Text(
  //             'Additional Information',
  //             style: TextStyle(
  //               color: AppTheme.textPrimary,
  //               fontSize: 18,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 24),
  //       CustomDropdown(
  //         isRequired: true,
  //         items: const ['Yes', 'No'],
  //         label: 'Eligible For Zakath',
  //         onChanged: cubit.updateZakath,
  //         value: state.zakath,
  //       ),
  //     ],
  //   );
  // }

  Widget _buildActionButtons(
      BuildContext context, FamilyMemberCubit cubit, FamilyMemberState state) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 52,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GradientButton(
            icon: Icons.check_circle_rounded,
            onPressed: () {
              if (cubit.validateAndSave()) {
                Navigator.pop(context, {
                  'member': state.toEntity(),
                  'isEditing': isEditing,
                  'memberIndex': memberIndex,
                });
              }
            },
            text: isEditing ? 'Update' : 'Save',
          ),
        ),
      ],
    );
  }
}
