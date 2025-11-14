import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmf/domain/entities/family_member.dart';
import 'package:mmf/domain/entities/form_data.dart';
import 'package:mmf/domain/usecases/submit_form.dart';
import 'package:mmf/presentation/cubits/main_form_state.dart';

class MainFormCubit extends Cubit<MainFormState> {
  final SubmitForm submitForm;

  MainFormCubit({required this.submitForm}) : super(const MainFormState());

  void addFamilyMember(FamilyMember member) {
    final updatedMembers = List<FamilyMember>.from(state.familyMembers)..add(member);
    emit(state.copyWith(familyMembers: updatedMembers));
  }

  void removeFamilyMember(int index) {
    if (index >= 0 && index < state.familyMembers.length) {
      final updatedMembers = List<FamilyMember>.from(state.familyMembers)..removeAt(index);
      emit(state.copyWith(familyMembers: updatedMembers));
    }
  }

  void updateFamilyMember(int index, FamilyMember member) {
    if (index >= 0 && index < state.familyMembers.length) {
      final updatedMembers = List<FamilyMember>.from(state.familyMembers);
      updatedMembers[index] = member;
      emit(state.copyWith(familyMembers: updatedMembers));
    }
  }

  void clearFamilyMembers() {
    emit(state.copyWith(familyMembers: []));
  }

  Future<void> submit(FormData formData) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await submitForm(formData);

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        error: failure.message,
      )),
      (_) {
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          familyMembers: [],
        ));
        // Reset success flag after a brief moment
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!isClosed) {
            emit(state.copyWith(isSuccess: false));
          }
        });
      },
    );
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}