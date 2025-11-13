import 'package:equatable/equatable.dart';

abstract class FormState extends Equatable {
  const FormState();

  @override
  List<Object?> get props => [];
}

class FormInitial extends FormState {}

class FormLoading extends FormState {}

class FormSuccess extends FormState {}

class FormError extends FormState {
  final String message;

  const FormError(this.message);

  @override
  List<Object?> get props => [message];
}