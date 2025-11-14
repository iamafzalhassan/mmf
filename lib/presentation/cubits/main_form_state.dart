import 'package:equatable/equatable.dart';
import 'package:mmf/domain/entities/family_member.dart';

class MainFormState extends Equatable {
  final List<FamilyMember> familyMembers;
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  const MainFormState({
    this.familyMembers = const [],
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });

  @override
  List<Object?> get props => [familyMembers, isLoading, isSuccess, error];

  MainFormState copyWith({
    List<FamilyMember>? familyMembers,
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return MainFormState(
      familyMembers: familyMembers ?? this.familyMembers,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }
}