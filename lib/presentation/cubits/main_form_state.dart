import 'package:equatable/equatable.dart';
import 'package:mmf/domain/entities/family_member.dart';

class MainFormState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String address;
  final String admissionNo;
  final String familiesCount;
  final String ownership;
  final String refNo;
  final String route;
  final String? error;
  final List<FamilyMember> familyMembers;

  const MainFormState({
    this.isLoading = false,
    this.isSuccess = false,
    this.address = '',
    this.admissionNo = '',
    this.familiesCount = '',
    this.ownership = '',
    required this.refNo,
    this.route = '',
    this.error,
    this.familyMembers = const [],
  });

  @override
  List<Object?> get props => [
    isLoading,
    isSuccess,
    address,
    admissionNo,
    familiesCount,
    ownership,
    refNo,
    route,
    error,
    familyMembers,
  ];

  MainFormState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? address,
    String? admissionNo,
    String? familiesCount,
    String? ownership,
    String? refNo,
    String? route,
    String? error,
    List<FamilyMember>? familyMembers,
  }) {
    return MainFormState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      address: address ?? this.address,
      admissionNo: admissionNo ?? this.admissionNo,
      familiesCount: familiesCount ?? this.familiesCount,
      ownership: ownership ?? this.ownership,
      refNo: refNo ?? this.refNo,
      route: route ?? this.route,
      error: error,
      familyMembers: familyMembers ?? this.familyMembers,
    );
  }
}