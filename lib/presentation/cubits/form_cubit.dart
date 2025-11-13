import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmf/domain/entities/family_member.dart';
import 'package:mmf/domain/entities/form_data.dart';
import 'package:mmf/domain/usecases/submit_form.dart';
import 'form_state.dart';

class FormCubit extends Cubit<FormState> {
  final SubmitForm submitForm;
  final List<FamilyMember> familyMembers = [];

  FormCubit({required this.submitForm}) : super(FormInitial());

  void addFamilyMember(FamilyMember member) {
    familyMembers.add(member);
  }

  void removeFamilyMember(int index) {
    if (index >= 0 && index < familyMembers.length) {
      familyMembers.removeAt(index);
    }
  }

  void updateFamilyMember(int index, FamilyMember member) {
    if (index >= 0 && index < familyMembers.length) {
      familyMembers[index] = member;
    }
  }

  void clearFamilyMembers() {
    familyMembers.clear();
  }

  Future<void> submit(FormData formData) async {
    emit(FormLoading());

    final result = await submitForm(formData);

    result.fold(
      (failure) => emit(FormError(failure.message)),
      (_) {
        clearFamilyMembers();
        emit(FormSuccess());
      },
    );
  }
}