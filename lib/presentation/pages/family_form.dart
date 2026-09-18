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
import 'package:mmf/presentation/widgets/page_title.dart';
import 'package:mmf/presentation/widgets/snack_bars.dart';

class FamilyForm extends StatefulWidget {
  const FamilyForm({super.key, this.existingMember});

  final FamilyMember? existingMember;

  @override
  State<FamilyForm> createState() => FamilyFormState();
}

class FamilyFormState extends State<FamilyForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final FamilyMemberCubit cubit = FamilyMemberCubit(widget.existingMember ?? const FamilyMember());

  bool get isEditing => widget.existingMember != null;

  Widget buildHeader(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: 32, top: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, 2))], color: AppTheme.white1),
            height: 40,
            width: 40,
            child: Material(color: Colors.transparent, child: InkWell(borderRadius: BorderRadius.circular(50), onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back_rounded, color: AppTheme.black, size: 20)))),
        const SizedBox(height: 16),
        PageTitle(isEditing ? 'Edit Family Member' : 'Add Family Member')
      ]));

  Widget buildPersonalInfo(FamilyMember member) {
    final isHead = member.relationship == 'Head of Family';
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Row(children: [Icon(Icons.person_rounded, color: AppTheme.green2, size: 24), SizedBox(width: 12), Text('Personal Information', style: TextStyle(color: AppTheme.black, fontSize: 18, fontWeight: FontWeight.w600))]),
      const SizedBox(height: 24),
      CustomTextField(hintText: 'Enter full name', initialValue: member.fullName, isRequired: true, label: 'Full Name', onChanged: cubit.updateName),
      const SizedBox(height: 20),
      CustomDropdown(isRequired: true, items: const ['Male', 'Female'], label: 'Gender', onChanged: cubit.updateGender, value: member.gender),
      const SizedBox(height: 20),
      CustomTextField(hintText: 'Enter age', initialValue: member.age, inputFormatters: [FilteringTextInputFormatter.digitsOnly], isRequired: true, keyboardType: TextInputType.number, label: 'Age', onChanged: cubit.updateAge),
      const SizedBox(height: 20),
      CustomTextField(
          hintText: 'Enter phone number',
          initialValue: member.mobile,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
          isRequired: isHead,
          keyboardType: TextInputType.phone,
          label: 'Mobile No',
          onChanged: cubit.updateMobile,
          validator: (value) => isHead && (value?.isEmpty ?? true) ? 'Mobile number is required for Head of Family' : phoneError(value, 'Invalid mobile number')),
      const SizedBox(height: 20),
      CustomTextField(
          hintText: 'Enter WhatsApp number',
          initialValue: member.whatsappNo,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
          keyboardType: TextInputType.phone,
          label: 'WhatsApp No',
          onChanged: cubit.updateWhatsappNo,
          validator: (value) => phoneError(value, 'Invalid WhatsApp number')),
      const SizedBox(height: 20),
      CustomTextField(hintText: 'Enter NIC', initialValue: member.nationalIdNo, label: 'National ID No', onChanged: cubit.updateNic),
      const SizedBox(height: 20),
      CustomDropdown(isRequired: true, items: const ['Studying Only', 'Working Only', 'Studying and Working', 'Not Working/Studying'], label: 'Status', onChanged: cubit.updateStatus, value: member.status),
      const SizedBox(height: 20),
      if (member.status == 'Working Only' || member.status == 'Studying and Working') ...[
        CustomTextField(hintText: 'Enter Occupation/Business', initialValue: member.occupation, isRequired: true, label: 'Occupation/Business', onChanged: cubit.updateOccupation),
        const SizedBox(height: 20)
      ],
      CustomDropdown(isRequired: true, items: const ['Married', 'Single', 'Divorced', 'Widow'], label: 'Civil Status', onChanged: cubit.updateCivilStatus, value: member.civilStatus),
      const SizedBox(height: 20),
      CustomDropdown(isRequired: true, items: FamilyMemberCubit.relationshipsFor(member.gender), label: 'Relationship to Head', onChanged: cubit.updateRelationship, value: member.relationship)
    ]);
  }

  String? phoneError(String? value, String message) => (value?.isNotEmpty ?? false) && (value!.length != 10 || !value.startsWith('07')) ? message : null;

  Widget buildSection(IconData icon, String title, List<Widget> children) => Container(
      decoration: BoxDecoration(border: Border.all(color: AppTheme.gray3), borderRadius: BorderRadius.circular(16), color: AppTheme.white5.withValues(alpha: 0.3)),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Icon(icon, color: AppTheme.green2, size: 22), const SizedBox(width: 10), Text(title, style: const TextStyle(color: AppTheme.black, fontSize: 16, fontWeight: FontWeight.w600))]),
        const SizedBox(height: 16),
        ...children
      ]));

  Widget buildActionButtons(BuildContext context) => Row(children: [
        Expanded(
            child: SizedBox(
                height: 52, child: OutlinedButton(onPressed: () => Navigator.pop(context), style: OutlinedButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.zero), child: const Text('Cancel', style: TextStyle(fontSize: 18))))),
        const SizedBox(width: 16),
        Expanded(
            child: GradientButton(
                icon: Icons.check_circle_rounded,
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    Navigator.pop(context, cubit.state);
                  } else {
                    context.showErrorSnackBar('Please fill all required fields correctly.');
                  }
                },
                text: isEditing ? 'Update' : 'Add'))
      ]);

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Container(
          decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
          child: BlocBuilder<FamilyMemberCubit, FamilyMember>(
              bloc: cubit,
              builder: (context, member) => SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    buildHeader(context),
                    Form(
                        key: formKey,
                        child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppTheme.white1),
                            padding: const EdgeInsets.all(16),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              buildPersonalInfo(member),
                              const SizedBox(height: 32),
                              const Divider(height: 1),
                              const SizedBox(height: 32),
                              buildSection(Icons.favorite_rounded, 'Special Needs', [
                                CheckboxGrid(items: const ['Disabled', 'Medical Support', 'Education Support', 'Converted'], onChanged: cubit.toggleSpecialNeeds, selectedItems: member.specialNeeds)
                              ]),
                              const SizedBox(height: 24),
                              buildSection(Icons.local_library_rounded, 'School Education', [
                                CheckboxGrid(items: const ['Primary', 'Above Grade 8', 'O/L', 'A/L', 'Abroad Student'], onChanged: cubit.toggleSchoolEducation, selectedItems: member.schoolEducation),
                                if (member.schoolEducation.contains('A/L')) ...[
                                  const SizedBox(height: 16),
                                  CustomTextField(
                                      hintText: 'Enter A/L year (e.g. 2020)',
                                      initialValue: member.alYear,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                                      isRequired: true,
                                      keyboardType: TextInputType.number,
                                      label: 'A/L Year',
                                      onChanged: cubit.updateAlYear,
                                      validator: (value) {
                                        if (value?.isEmpty ?? true) return 'A/L year is required';
                                        final year = int.tryParse(value!);
                                        return year == null || year < 1950 || year > DateTime.now().year + 1 ? 'Enter a valid year' : null;
                                      })
                                ]
                              ]),
                              const SizedBox(height: 24),
                              buildSection(Icons.school_rounded, 'Professional Qualifications', [
                                CheckboxGrid(
                                    items: const ['Certificate', 'Diploma', 'Degree', "Master's Degree", 'Phd', 'Vocational Course'], onChanged: cubit.toggleProfessionalQualification, selectedItems: member.professionalQualifications),
                                if (member.professionalQualifications.isNotEmpty) ...[
                                  const SizedBox(height: 16),
                                  CustomTextField(
                                      hintText: 'e.g. Diploma in Nursing, BSc in Psychology, Plumbing, Electrical',
                                      initialValue: member.professionalQualificationsDetails,
                                      isRequired: true,
                                      label: 'Qualification Details',
                                      onChanged: cubit.updateProfessionalQualificationsDetails,
                                      validator: (value) => (value?.isEmpty ?? true) ? 'Please specify your qualifications' : null)
                                ],
                                if (member.professionalQualifications.contains('Vocational Course')) ...[
                                  const SizedBox(height: 16),
                                  CustomTextField(
                                      hintText: 'e.g. Plumbing, Electrical, Welding',
                                      initialValue: member.vocationalCourseDetails,
                                      isRequired: true,
                                      label: 'Vocational Course Details',
                                      onChanged: cubit.updateVocationalCourseDetails,
                                      validator: (value) => (value?.isEmpty ?? true) ? 'Please specify your vocational course' : null)
                                ]
                              ]),
                              const SizedBox(height: 24),
                              buildSection(Icons.local_library_rounded, 'Madarasa Education', [
                                CheckboxGrid(items: const ['Kitab Part Time', 'Kitab Full Time', 'Hifz Part Time', 'Hifz Full Time'], onChanged: cubit.toggleMadarasa, selectedItems: member.madarasa)
                              ]),
                              const SizedBox(height: 24),
                              buildSection(Icons.school_rounded, 'Ulama Qualifications', [CheckboxGrid(items: FamilyMemberCubit.ulamaFor(member.gender), onChanged: cubit.toggleUlama, selectedItems: member.ulama)]),
                              const SizedBox(height: 32),
                              buildActionButtons(context)
                            ])))
                  ])))));
}
