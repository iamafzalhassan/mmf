import 'package:flutter/material.dart' hide FormState;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmf/core/di/injection_container.dart' as di;
import 'package:mmf/core/utils/date_utils.dart';
import 'package:mmf/domain/entities/form_data.dart';
import 'package:mmf/presentation/cubits/form_cubit.dart';
import 'package:mmf/presentation/cubits/form_state.dart';
import 'package:mmf/presentation/widgets/custom_dropdown_field.dart';
import 'package:mmf/presentation/widgets/gradient_button.dart';
import 'package:mmf/presentation/widgets/section_header.dart';
import 'family_form.dart';

class MahallaForm extends StatelessWidget {
  const MahallaForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<FormCubit>(),
      child: const MahallaFormView(),
    );
  }
}

class MahallaFormView extends StatefulWidget {
  const MahallaFormView({super.key});

  @override
  State<MahallaFormView> createState() => _MahallaFormViewState();
}

class _MahallaFormViewState extends State<MahallaFormView> {
  final _scrollController = ScrollController();

  // Controllers
  late final TextEditingController _refNoController;
  late final TextEditingController _admissionNoController;
  late final TextEditingController _headNameController;
  late final TextEditingController _headInitialsController;
  late final TextEditingController _addressController;
  late final TextEditingController _headNICController;
  late final TextEditingController _headAgeController;
  late final TextEditingController _mobileController;
  late final TextEditingController _occupationController;

  // Dropdown values
  String _headGender = '';
  String _headCivilStatus = '';
  String _ownership = '';
  String _zakath = '';

  @override
  void initState() {
    super.initState();
    _refNoController =
        TextEditingController(text: DateTimeUtils.generateRefNo());
    _admissionNoController = TextEditingController();
    _headNameController = TextEditingController();
    _headInitialsController = TextEditingController();
    _addressController = TextEditingController();
    _headNICController = TextEditingController();
    _headAgeController = TextEditingController();
    _mobileController = TextEditingController();
    _occupationController = TextEditingController();
  }

  @override
  void dispose() {
    _refNoController.dispose();
    _admissionNoController.dispose();
    _headNameController.dispose();
    _headInitialsController.dispose();
    _addressController.dispose();
    _headNICController.dispose();
    _headAgeController.dispose();
    _mobileController.dispose();
    _occupationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _refNoController.text = DateTimeUtils.generateRefNo();
    _admissionNoController.clear();
    _headNameController.clear();
    _headInitialsController.clear();
    _addressController.clear();
    _headNICController.clear();
    _headAgeController.clear();
    _mobileController.clear();
    _occupationController.clear();
    setState(() {
      _headGender = '';
      _headCivilStatus = '';
      _ownership = '';
      _zakath = '';
    });
  }

  void _submitForm() {
    final formData = FormData(
      refNo: _refNoController.text,
      admissionNo: _admissionNoController.text,
      headName: _headNameController.text,
      headInitials: _headInitialsController.text,
      address: _addressController.text,
      headNIC: _headNICController.text,
      headAge: _headAgeController.text,
      mobile: _mobileController.text,
      occupation: _occupationController.text,
      headGender: _headGender,
      headCivilStatus: _headCivilStatus,
      ownership: _ownership,
      zakath: _zakath,
      familyMembers: context.read<FormCubit>().familyMembers,
    );

    context.read<FormCubit>().submit(formData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: BlocListener<FormCubit, FormState>(
        listener: (context, state) {
          if (state is FormSuccess) {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Form submitted successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            _resetForm();
          } else if (state is FormError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(32),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeadOfFamilySection(),
                      _buildFamilyMembersSection(),
                      _buildAdditionalInformationSection(),
                      const SizedBox(height: 32),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: const Column(
        children: [
          Text(
            'KOHILAWATTA JUMMAH MASJID & BURIAL GROUND',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Mahalla Members Details Collection Form',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHeadOfFamilySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Head of Family Details',
          icon: Icons.person,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _admissionNoController,
          decoration: const InputDecoration(
            labelText: 'Admission (Sandapaname) No',
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _headNameController,
          decoration: const InputDecoration(labelText: 'Full Name *'),
          validator: (val) => val?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _headInitialsController,
          decoration: const InputDecoration(labelText: 'Name with Initials *'),
          validator: (val) => val?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(labelText: 'Address *'),
          validator: (val) => val?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _headNICController,
                decoration:
                    const InputDecoration(labelText: 'National ID No *'),
                validator: (val) => val?.isEmpty ?? true ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _headAgeController,
                decoration: const InputDecoration(labelText: 'Age *'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (val) => val?.isEmpty ?? true ? 'Required' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _mobileController,
                decoration: const InputDecoration(
                  labelText: 'Mobile No *',
                  hintText: '07XXXXXXXX',
                ),
                keyboardType: TextInputType.phone,
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
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _occupationController,
                decoration:
                    const InputDecoration(labelText: 'Occupation/Business *'),
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
                value: _headGender,
                items: const ['Male', 'Female'],
                onChanged: (val) => setState(() => _headGender = val),
                isRequired: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomDropdownField(
                label: 'Civil Status',
                value: _headCivilStatus,
                items: const ['Married', 'Single', 'Divorced', 'Widow'],
                onChanged: (val) => setState(() => _headCivilStatus = val),
                isRequired: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomDropdownField(
          label: 'House Ownership',
          value: _ownership,
          items: const ['Own', 'Rent'],
          onChanged: (val) => setState(() => _ownership = val),
          isRequired: true,
        ),
      ],
    );
  }

  Widget _buildFamilyMembersSection() {
    return BlocBuilder<FormCubit, FormState>(
      builder: (context, state) {
        final cubit = context.read<FormCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Family Members',
              icon: Icons.family_restroom,
            ),
            const SizedBox(height: 16),
            ...List.generate(
              cubit.familyMembers.length,
              (index) => FamilyMemberCard(
                index: index,
                onRemove: () {
                  cubit.removeFamilyMember(index);
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 16),
            GradientButton(
              text: 'Add Family Member',
              onPressed: () async {
                final member = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FamilyForm(),
                  ),
                );
                if (member != null) {
                  cubit.addFamilyMember(member);
                  setState(() {});
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildAdditionalInformationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Additional Information',
          icon: Icons.info_outline,
        ),
        const SizedBox(height: 16),
        CustomDropdownField(
          label: 'Eligible For Zakath',
          value: _zakath,
          items: const ['Yes', 'No'],
          onChanged: (val) => setState(() => _zakath = val),
          isRequired: true,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<FormCubit, FormState>(
      builder: (context, state) {
        return GradientButton(
          text: 'Submit Form',
          onPressed: _submitForm,
          isLoading: state is FormLoading,
        );
      },
    );
  }
}

class FamilyMemberCard extends StatelessWidget {
  final int index;
  final VoidCallback onRemove;

  const FamilyMemberCard({
    super.key,
    required this.index,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side:
            BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Family Member ${index + 1}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}