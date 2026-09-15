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
import 'package:mmf/presentation/widgets/snack_bars.dart';

class FamilyForm extends StatefulWidget {
  const FamilyForm({super.key, this.memberIndex, this.existingMember});

  final int? memberIndex;

  final FamilyMember? existingMember;

  @override
  State<FamilyForm> createState() => FamilyFormState();
}

class FamilyFormState extends State<FamilyForm> {
  final FamilyMemberCubit cubit = FamilyMemberCubit();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController ageController = TextEditingController();
  final TextEditingController alYearController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController nationalIdNoController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController professionalQualificationsDetailsController = TextEditingController();
  final TextEditingController vocationalCourseDetailsController = TextEditingController();
  final TextEditingController whatsappNoController = TextEditingController();

  bool get isEditing => widget.existingMember != null;

  Widget buildHeader(BuildContext context) => Container(
      padding: const EdgeInsets.only(bottom: 32, top: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.05), offset: const Offset(0, 2))], color: AppTheme.white1),
            height: 40,
            width: 40,
            child:
                Material(color: Colors.transparent, child: InkWell(borderRadius: BorderRadius.circular(50), onTap: () => Navigator.pop(context), child: const Center(child: Icon(Icons.arrow_back_rounded, color: AppTheme.black, size: 20))))),
        const SizedBox(height: 16),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Stack(children: [
            Text(isEditing ? 'Edit Family Member' : 'Add Family Member',
                style: TextStyle(
                    fontSize: 32,
                    foreground: Paint()
                      ..color = AppTheme.black
                      ..strokeWidth = 1.25
                      ..style = PaintingStyle.stroke,
                    height: 1)),
            Text(isEditing ? 'Edit Family Member' : 'Add Family Member', style: const TextStyle(color: AppTheme.black, fontSize: 32, height: 1))
          ])
        ])
      ]));

  Widget buildPersonalInfoSection(FamilyMemberCubit cubit, FamilyMemberState state) {
    final isHeadOfFamily = state.relationship == 'Head of Family';
    final shouldShowOccupation = state.status == 'Working Only' || state.status == 'Studying and Working';

    List<String> relationshipItems;
    if (state.gender == 'Male') {
      relationshipItems = const ['Head of Family', 'Spouse', 'Son', 'Father', 'Brother', 'Grandson', 'Other'];
    } else if (state.gender == 'Female') {
      relationshipItems = const ['Head of Family', 'Spouse', 'Daughter', 'Mother', 'Sister', 'Granddaughter', 'Other'];
    } else {
      relationshipItems = const ['Head of Family', 'Spouse', 'Son', 'Daughter', 'Father', 'Mother', 'Brother', 'Sister', 'Grandson', 'Granddaughter', 'Other'];
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Row(children: [Icon(Icons.person_rounded, color: AppTheme.green2, size: 24), SizedBox(width: 12), Text('Personal Information', style: TextStyle(color: AppTheme.black, fontSize: 18, fontWeight: FontWeight.w600))]),
      const SizedBox(height: 24),
      CustomTextField(controller: fullNameController, hintText: 'Enter full name', isRequired: true, label: 'Full Name', onChanged: cubit.updateName),
      const SizedBox(height: 20),
      CustomDropdown(isRequired: true, items: const ['Male', 'Female'], label: 'Gender', onChanged: cubit.updateGender, value: state.gender),
      const SizedBox(height: 20),
      CustomTextField(controller: ageController, hintText: 'Enter age', inputFormatters: [FilteringTextInputFormatter.digitsOnly], isRequired: true, keyboardType: TextInputType.number, label: 'Age', onChanged: cubit.updateAge),
      const SizedBox(height: 20),
      CustomTextField(
          controller: mobileNoController,
          hintText: 'Enter phone number',
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
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
          }),
      const SizedBox(height: 20),
      CustomTextField(
          controller: whatsappNoController,
          hintText: 'Enter WhatsApp number',
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
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
          }),
      const SizedBox(height: 20),
      CustomTextField(controller: nationalIdNoController, hintText: 'Enter NIC', label: 'National ID No', onChanged: cubit.updateNic),
      const SizedBox(height: 20),
      CustomDropdown(isRequired: true, items: const ['Studying Only', 'Working Only', 'Studying and Working', 'Not Working/Studying'], label: 'Status', onChanged: cubit.updateStatus, value: state.status),
      const SizedBox(height: 20),
      if (shouldShowOccupation) CustomTextField(controller: occupationController, hintText: 'Enter Occupation/Business', isRequired: true, label: 'Occupation/Business', onChanged: cubit.updateOccupation),
      if (shouldShowOccupation) const SizedBox(height: 20),
      CustomDropdown(isRequired: true, items: const ['Married', 'Single', 'Divorced', 'Widow'], label: 'Civil Status', onChanged: cubit.updateCivilStatus, value: state.civilStatus),
      const SizedBox(height: 20),
      CustomDropdown(isRequired: true, items: relationshipItems, label: 'Relationship to Head', onChanged: cubit.updateRelationship, value: state.relationship)
    ]);
  }

  Widget buildSpecialNeedsSection(FamilyMemberCubit cubit, FamilyMemberState state) => Container(
      decoration: BoxDecoration(border: Border.all(color: AppTheme.gray3), borderRadius: BorderRadius.circular(16), color: AppTheme.white5.withOpacity(0.3)),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [Icon(Icons.favorite_rounded, color: AppTheme.green2, size: 22), SizedBox(width: 10), Text('Special Needs', style: TextStyle(color: AppTheme.black, fontSize: 16, fontWeight: FontWeight.w600))]),
        const SizedBox(height: 16),
        CheckboxGrid(items: const ['Disabled', 'Medical Support', 'Education Support', 'Converted'], onChanged: cubit.toggleSpecialNeeds, selectedItems: state.specialNeeds)
      ]));

  Widget buildSchoolEducationSection(FamilyMemberCubit cubit, FamilyMemberState state) => Container(
      decoration: BoxDecoration(border: Border.all(color: AppTheme.gray3), borderRadius: BorderRadius.circular(16), color: AppTheme.white5.withOpacity(0.3)),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [Icon(Icons.local_library_rounded, color: AppTheme.green2, size: 22), SizedBox(width: 10), Text('School Education', style: TextStyle(color: AppTheme.black, fontSize: 16, fontWeight: FontWeight.w600))]),
        const SizedBox(height: 16),
        CheckboxGrid(items: const ['Primary', 'Above Grade 8', 'O/L', 'A/L', 'Abroad Student'], onChanged: cubit.toggleSchoolEducation, selectedItems: state.schoolEducation),
        if (state.schoolEducation.contains('A/L')) ...[
          const SizedBox(height: 16),
          CustomTextField(
              controller: alYearController,
              hintText: 'Enter A/L year (e.g. 2020)',
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
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
              })
        ]
      ]));

  Widget buildProfessionalQualificationsSection(FamilyMemberCubit cubit, FamilyMemberState state) {
    final hasProfessionalQualifications = state.professionalQualifications.isNotEmpty;

    return Container(
        decoration: BoxDecoration(border: Border.all(color: AppTheme.gray3), borderRadius: BorderRadius.circular(16), color: AppTheme.white5.withOpacity(0.3)),
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [Icon(Icons.school_rounded, color: AppTheme.green2, size: 22), SizedBox(width: 10), Text('Professional Qualifications', style: TextStyle(color: AppTheme.black, fontSize: 16, fontWeight: FontWeight.w600))]),
          const SizedBox(height: 16),
          CheckboxGrid(items: const ['Certificate', 'Diploma', 'Degree', "Master's Degree", 'Phd', 'Vocational Course'], onChanged: cubit.toggleProfessionalQualification, selectedItems: state.professionalQualifications),
          if (hasProfessionalQualifications) ...[
            const SizedBox(height: 16),
            CustomTextField(
                controller: professionalQualificationsDetailsController,
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
                })
          ],
          if (state.professionalQualifications.contains('Vocational Course')) ...[
            const SizedBox(height: 16),
            CustomTextField(
                controller: vocationalCourseDetailsController,
                hintText: 'e.g. Plumbing, Electrical, Welding',
                isRequired: true,
                label: 'Vocational Course Details',
                maxLines: 1,
                onChanged: cubit.updateVocationalCourseDetails,
                validator: (val) {
                  if (val?.isEmpty ?? true) {
                    return 'Please specify your vocational course';
                  }
                  return null;
                })
          ]
        ]));
  }

  Widget buildMadarasaEducationSection(FamilyMemberCubit cubit, FamilyMemberState state) => Container(
      decoration: BoxDecoration(border: Border.all(color: AppTheme.gray3), borderRadius: BorderRadius.circular(16), color: AppTheme.white5.withOpacity(0.3)),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [Icon(Icons.local_library_rounded, color: AppTheme.green2, size: 22), SizedBox(width: 10), Text('Madarasa Education', style: TextStyle(color: AppTheme.black, fontSize: 16, fontWeight: FontWeight.w600))]),
        const SizedBox(height: 16),
        CheckboxGrid(items: const ['Kitab Part Time', 'Kitab Full Time', 'Hifz Part Time', 'Hifz Full Time'], onChanged: cubit.toggleMadarasa, selectedItems: state.madarasa)
      ]));

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
        decoration: BoxDecoration(border: Border.all(color: AppTheme.gray3), borderRadius: BorderRadius.circular(16), color: AppTheme.white5.withOpacity(0.3)),
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [Icon(Icons.school_rounded, color: AppTheme.green2, size: 22), SizedBox(width: 10), Text('Ulama Qualifications', style: TextStyle(color: AppTheme.black, fontSize: 16, fontWeight: FontWeight.w600))]),
          const SizedBox(height: 16),
          CheckboxGrid(items: ulamaItems, onChanged: cubit.toggleUlama, selectedItems: state.ulama)
        ]));
  }

  Widget buildActionButtons(BuildContext context, FamilyMemberCubit cubit, FamilyMemberState state) => Row(children: [
        Expanded(
            child: SizedBox(
                height: 52,
                child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ButtonStyle(minimumSize: WidgetStateProperty.all<Size>(const Size(0, 0)), padding: WidgetStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(0))),
                    child: const Text('Cancel', style: TextStyle(fontSize: 18))))),
        const SizedBox(width: 16),
        Expanded(
            child: GradientButton(
                icon: Icons.check_circle_rounded,
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    Navigator.pop(context, {'isEditing': isEditing, 'member': state.toEntity(), 'memberIndex': widget.memberIndex});
                  } else {
                    context.showErrorSnackBar('Please fill all required fields correctly.');
                  }
                },
                text: isEditing ? 'Update' : 'Add'))
      ]);

  void clearHiddenFields(BuildContext context, FamilyMemberState state) {
    if (state.alYear.isEmpty && alYearController.text.isNotEmpty) alYearController.clear();
    if (state.professionalQualificationsDetails.isEmpty && professionalQualificationsDetailsController.text.isNotEmpty) professionalQualificationsDetailsController.clear();
    if (state.vocationalCourseDetails.isEmpty && vocationalCourseDetailsController.text.isNotEmpty) vocationalCourseDetailsController.clear();
  }

  @override
  void initState() {
    super.initState();
    final member = widget.existingMember;
    if (member == null) return;
    cubit.loadMember(member);
    ageController.text = member.age;
    alYearController.text = member.alYear;
    fullNameController.text = member.fullName;
    mobileNoController.text = member.mobile;
    nationalIdNoController.text = member.nationalIdNo;
    occupationController.text = member.occupation;
    professionalQualificationsDetailsController.text = member.professionalQualificationsDetails;
    vocationalCourseDetailsController.text = member.vocationalCourseDetails;
    whatsappNoController.text = member.whatsappNo;
  }

  @override
  void dispose() {
    ageController.dispose();
    alYearController.dispose();
    fullNameController.dispose();
    mobileNoController.dispose();
    nationalIdNoController.dispose();
    occupationController.dispose();
    professionalQualificationsDetailsController.dispose();
    vocationalCourseDetailsController.dispose();
    whatsappNoController.dispose();
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
      value: cubit,
      child: Scaffold(
          body: Container(
              decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
              child: BlocConsumer<FamilyMemberCubit, FamilyMemberState>(
                  listener: clearHiddenFields,
                  builder: (context, state) => SingleChildScrollView(
                      child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(children: [
                            buildHeader(context),
                            Form(
                                key: formKey,
                                child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppTheme.white1),
                                    child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          buildPersonalInfoSection(cubit, state),
                                          const SizedBox(height: 32),
                                          const Divider(height: 1),
                                          const SizedBox(height: 32),
                                          buildSpecialNeedsSection(cubit, state),
                                          const SizedBox(height: 24),
                                          buildSchoolEducationSection(cubit, state),
                                          const SizedBox(height: 24),
                                          buildProfessionalQualificationsSection(cubit, state),
                                          const SizedBox(height: 24),
                                          buildMadarasaEducationSection(cubit, state),
                                          const SizedBox(height: 24),
                                          buildUlamaQualificationsSection(cubit, state),
                                          const SizedBox(height: 32),
                                          buildActionButtons(context, cubit, state)
                                        ]))))
                          ])))))));
}
