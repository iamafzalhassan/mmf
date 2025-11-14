import 'package:equatable/equatable.dart';
import 'package:mmf/core/utils/date_utils.dart';
import 'package:mmf/domain/entities/family_member.dart';

class MainFormState extends Equatable {
  final String refNo;
  final String admissionNo;
  final String address;
  final String mobile;
  final String ownership;
  final String zakath;
  final List<FamilyMember> familyMembers;
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  const MainFormState({
    required this.refNo,
    this.admissionNo = '',
    this.address = '',
    this.mobile = '',
    this.ownership = '',
    this.zakath = '',
    this.familyMembers = const [],
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });

  factory MainFormState.initial() {
    return MainFormState(
      refNo: DateTimeUtils.generateRefNo(),
    );
  }

  @override
  List<Object?> get props => [
    refNo,
    admissionNo,
    address,
    mobile,
    ownership,
    zakath,
    familyMembers,
    isLoading,
    isSuccess,
    error,
  ];

  MainFormState copyWith({
    String? refNo,
    String? admissionNo,
    String? address,
    String? mobile,
    String? ownership,
    String? zakath,
    List<FamilyMember>? familyMembers,
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return MainFormState(
      refNo: refNo ?? this.refNo,
      admissionNo: admissionNo ?? this.admissionNo,
      address: address ?? this.address,
      mobile: mobile ?? this.mobile,
      ownership: ownership ?? this.ownership,
      zakath: zakath ?? this.zakath,
      familyMembers: familyMembers ?? this.familyMembers,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }
}