import 'package:equatable/equatable.dart';
import 'package:mmf/domain/entities/family_member.dart';

class MainFormState extends Equatable {
  final String refNo;
  final String admissionNo;
  final String address;
  final String ownership;
  final String familiesCount;
  final List<FamilyMember> familyMembers;
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  const MainFormState({
    required this.refNo,
    this.admissionNo = '',
    this.address = '',
    this.ownership = '',
    this.familiesCount = '',
    this.familyMembers = const [],
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });

  @override
  List<Object?> get props => [
        refNo,
        admissionNo,
        address,
        ownership,
        familiesCount,
        familyMembers,
        isLoading,
        isSuccess,
        error,
      ];

  MainFormState copyWith({
    String? refNo,
    String? admissionNo,
    String? address,
    String? ownership,
    String? familiesCount,
    List<FamilyMember>? familyMembers,
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return MainFormState(
      refNo: refNo ?? this.refNo,
      admissionNo: admissionNo ?? this.admissionNo,
      address: address ?? this.address,
      ownership: ownership ?? this.ownership,
      familiesCount: familiesCount ?? this.familiesCount,
      familyMembers: familyMembers ?? this.familyMembers,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }
}