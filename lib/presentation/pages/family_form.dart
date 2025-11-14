import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmf/presentation/cubits/family_member_cubit.dart';
import 'package:mmf/presentation/widgets/checkbox_grid.dart';
import 'package:mmf/presentation/widgets/custom_dropdown_field.dart';
import 'package:mmf/presentation/widgets/gradient_button.dart';

class FamilyForm extends StatefulWidget {
  const FamilyForm({super.key});

  @override
  State<FamilyForm> createState() => _FamilyMainFormState();
}

class _FamilyMainFormState extends State<FamilyForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _nicController;
  late final TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _nicController = TextEditingController();
    _ageController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FamilyMemberCubit(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('Add Family Member'),
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

            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name with Initials *',
                        ),
                        onChanged: cubit.updateName,
                        validator: (val) => val?.isEmpty ?? true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _nicController,
                              decoration: const InputDecoration(
                                labelText: 'National ID No',
                              ),
                              onChanged: cubit.updateNic,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _ageController,
                              decoration: const InputDecoration(
                                labelText: 'Age *',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: cubit.updateAge,
                              validator: (val) => val?.isEmpty ?? true ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomDropdownField(
                              label: 'Gender',
                              value: state.gender,
                              items: const ['Male', 'Female'],
                              onChanged: cubit.updateGender,
                              isRequired: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomDropdownField(
                              label: 'Civil Status',
                              value: state.civilStatus,
                              items: const [
                                'Married',
                                'Single',
                                'Divorced',
                                'Widow'
                              ],
                              onChanged: cubit.updateCivilStatus,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomDropdownField(
                              label: 'Status',
                              value: state.status,
                              items: const [
                                'Studying Only',
                                'Working Only',
                                'Studying and Working'
                              ],
                              onChanged: cubit.updateStatus,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomDropdownField(
                              label: 'Relationship to Head',
                              value: state.relationship,
                              items: const [
                                'Father',
                                'Mother',
                                'Son',
                                'Daughter',
                                'Brother',
                                'Sister',
                                'Spouse',
                                'Other'
                              ],
                              onChanged: cubit.updateRelationship,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildEducationSection(cubit, state),
                      const SizedBox(height: 16),
                      _buildMadarasaSection(cubit, state),
                      const SizedBox(height: 16),
                      _buildUlamaSection(cubit, state),
                      const SizedBox(height: 16),
                      _buildSpecialNeedsSection(cubit, state),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GradientButton(
                              text: 'Save Member',
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  final member = state.toEntity();
                                  Navigator.pop(context, member);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
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
          Row(
            children: [
              const Icon(Icons.school, color: Color(0xFF667EEA)),
              const SizedBox(width: 8),
              Text(
                'Education & Qualifications',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
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
          Row(
            children: [
              const Icon(Icons.menu_book, color: Color(0xFF667EEA)),
              const SizedBox(width: 8),
              Text(
                'Madarasa Education',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
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
          Row(
            children: [
              const Icon(Icons.auto_stories, color: Color(0xFF667EEA)),
              const SizedBox(width: 8),
              Text(
                'Ulama Qualifications',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
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
          Row(
            children: [
              const Icon(Icons.favorite, color: Color(0xFF667EEA)),
              const SizedBox(width: 8),
              Text(
                'Special Needs',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
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
}