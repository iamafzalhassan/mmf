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
                      buildHeader(context),
                      Form(
                        key: cubit.formKey,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppTheme.white1,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildPersonalInfoSection(
                                  cubit,
                                  state,
                                ),
                                const SizedBox(height: 32),
                                const Divider(height: 1),
                                const SizedBox(height: 32),
                                buildSpecialNeedsSection(
                                  cubit,
                                  state,
                                ),
                                const SizedBox(height: 24),
                                buildSchoolEducationSection(
                                  cubit,
                                  state,
                                ),
                                const SizedBox(height: 24),
                                buildProfessionalQualificationsSection(
                                  cubit,
                                  state,
                                ),
                                const SizedBox(height: 24),
                                buildMadarasaEducationSection(
                                  cubit,
                                  state,
                                ),
                                const SizedBox(height: 24),
                                buildUlamaQualificationsSection(
                                  cubit,
                                  state,
                                ),
                                const SizedBox(height: 32),
                                buildActionButtons(
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

  Widget buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 32, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 2),
                ),
              ],
              color: AppTheme.white1,
            ),
            height: 40,
            width: 40,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () => Navigator.pop(context),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: AppTheme.black,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Text(
                    isEditing ? 'Edit Family Member' : 'Add Family Member',
                    style: TextStyle(
                      fontSize: 32,
                      foreground: Paint()
                        ..color = AppTheme.black
                        ..strokeWidth = 1.25
                        ..style = PaintingStyle.stroke,
                      height: 1,
                    ),
                  ),
                  Text(
                    isEditing ? 'Edit Family Member' : 'Add Family Member',
                    style: const TextStyle(
                      color: AppTheme.black,
                      fontSize: 32,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildPersonalInfoSection(FamilyMemberCubit cubit, FamilyMemberState state) {
    final isHeadOfFamily = state.relationship == 'Head of Family';
    final shouldShowOccupation = state.status == 'Working Only' || state.status == 'Studying and Working';

    List<String> relationshipItems;
    if (state.gender == 'Male') {
      relationshipItems = const [
        'Head of Family',
        'Spouse',
        'Son',
        'Father',
        'Brother',
        'Grandson',
        'Other'
      ];
    } else if (state.gender == 'Female') {
      relationshipItems = const [
        'Head of Family',
        'Spouse',
        'Daughter',
        'Mother',
        'Sister',
        'Granddaughter',
        'Other'
      ];
    } else {
      relationshipItems = const [
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
      ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.person_rounded,
              color: AppTheme.green2,
              size: 24,
            ),
            SizedBox(width: 12),
            Text(
              'Personal Information',
              style: TextStyle(
                color: AppTheme.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        CustomTextField(
          controller: cubit.fullNameController,
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
          controller: cubit.mobileNoController,
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
          controller: cubit.whatsappNoController,
          hintText: 'Enter WhatsApp number',
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          keyboardType: TextInputType.phone,
          label: 'WhatsApp No',
          onChanged: cubit.updateWhatsappNo,
          validator: (val) {
            if (val != null && val.isNotEmpty) {
              if (val.length != 10 || !val.startsWith('07')) {
                return 'Invalid WhatsApp number';
              }
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: cubit.nationalIdNoController,
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
        if (shouldShowOccupation)
          CustomTextField(
            controller: cubit.occupationController,
            hintText: 'Enter Occupation/Business',
            isRequired: true,
            label: 'Occupation/Business',
            onChanged: cubit.updateOccupation,
          ),
        if (shouldShowOccupation) const SizedBox(height: 20),
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
          items: relationshipItems,
          label: 'Relationship to Head',
          onChanged: cubit.updateRelationship,
          value: state.relationship,
        ),
      ],
    );
  }

  Widget buildSpecialNeedsSection(FamilyMemberCubit cubit, FamilyMemberState state) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.gray3),
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.white5.withOpacity(0.3),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.favorite_rounded,
                color: AppTheme.green2,
                size: 22,
              ),
              SizedBox(width: 10),
              Text(
                'Special Needs',
                style: TextStyle(
                  color: AppTheme.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CheckboxGrid(
            items: const [
              'Disabled',
              'Medical Support',
              'Education Support',
              'Converted',
            ],
            onChanged: cubit.toggleSpecialNeeds,
            selectedItems: state.specialNeeds,
          ),
        ],
      ),
    );
  }

  Widget buildSchoolEducationSection(FamilyMemberCubit cubit, FamilyMemberState state) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.gray3),
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.white5.withOpacity(0.3),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.local_library_rounded,
                color: AppTheme.green2,
                size: 22,
              ),
              SizedBox(width: 10),
              Text(
                'School Education',
                style: TextStyle(
                  color: AppTheme.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CheckboxGrid(
            items: const [
              'Primary',
              'Above Grade 8',
              'O/L',
              'A/L',
              'Abroad Student',
            ],
            onChanged: cubit.toggleSchoolEducation,
            selectedItems: state.schoolEducation,
          ),
          if (state.schoolEducation.contains('A/L')) ...[
            const SizedBox(height: 16),
            CustomTextField(
              controller: cubit.alYearController,
              hintText: 'Enter A/L year (e.g. 2020)',
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              isRequired: true,
              keyboardType: TextInputType.number,
              label: 'A/L Year',
              onChanged: cubit.updateAlYear,
              validator: (val) {
                if (val?.isEmpty ?? true) {
                  return 'A/L year is required';
                }
                final year = int.tryParse(val!);
                if (year == null || year < 1950 || year > DateTime.now().year + 1) {
                  return 'Enter a valid year';
                }
                return null;
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget buildProfessionalQualificationsSection(FamilyMemberCubit cubit, FamilyMemberState state) {
    final hasProfessionalQualifications = state.professionalQualifications.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.gray3),
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.white5.withOpacity(0.3),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.school_rounded,
                color: AppTheme.green2,
                size: 22,
              ),
              SizedBox(width: 10),
              Text(
                'Professional Qualifications',
                style: TextStyle(
                  color: AppTheme.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CheckboxGrid(
            items: const [
              'Certificate',
              'Diploma',
              'Degree',
              "Master's Degree",
              'Phd',
              'Vocational Course',
            ],
            onChanged: cubit.toggleProfessionalQualification,
            selectedItems: state.professionalQualifications,
          ),
          if (hasProfessionalQualifications) ...[
            const SizedBox(height: 16),
            CustomTextField(
              controller: cubit.professionalQualificationsDetailsController,
              hintText: 'e.g. Diploma in Nursing, BSc in Psychology, Plumbing, Electrical',
              isRequired: true,
              label: 'Qualification Details',
              maxLines: 1,
              onChanged: cubit.updateProfessionalQualificationsDetails,
              validator: (val) {
                if (val?.isEmpty ?? true) {
                  return 'Please specify your qualifications';
                }
                return null;
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget buildMadarasaEducationSection(FamilyMemberCubit cubit, FamilyMemberState state) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.gray3),
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.white5.withOpacity(0.3),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.local_library_rounded,
                color: AppTheme.green2,
                size: 22,
              ),
              SizedBox(width: 10),
              Text(
                'Madarasa Education',
                style: TextStyle(
                  color: AppTheme.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
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
            onChanged: cubit.toggleMadarasa,
            selectedItems: state.madarasa,
          ),
        ],
      ),
    );
  }

  Widget buildUlamaQualificationsSection(FamilyMemberCubit cubit, FamilyMemberState state) {
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
        border: Border.all(color: AppTheme.gray3),
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.white5.withOpacity(0.3),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.school_rounded,
                color: AppTheme.green2,
                size: 22,
              ),
              SizedBox(width: 10),
              Text(
                'Ulama Qualifications',
                style: TextStyle(
                  color: AppTheme.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CheckboxGrid(
            items: ulamaItems,
            onChanged: cubit.toggleUlama,
            selectedItems: state.ulama,
          ),
        ],
      ),
    );
  }

  Widget buildActionButtons(BuildContext context, FamilyMemberCubit cubit, FamilyMemberState state) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 52,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all<Size>(const Size(0, 0)),
                padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.all(0),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 18),
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
                  'isEditing': isEditing,
                  'member': state.toEntity(),
                  'memberIndex': memberIndex,
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppTheme.red,
                    behavior: SnackBarBehavior.fixed,
                    content: const Row(
                      children: [
                        Icon(Icons.info_rounded, color: Colors.white),
                        SizedBox(width: 12),
                        Text('Please fill all required fields correctly.', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 100, left: 20, right: 20),
                  ),
                );
              }
            },
            text: isEditing ? 'Update' : 'Add',
          ),
        ),
      ],
    );
  }
}