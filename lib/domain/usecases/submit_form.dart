import 'package:dartz/dartz.dart';
import 'package:mmf/core/error/failures.dart';
import 'package:mmf/domain/entities/form_data.dart';
import 'package:mmf/domain/repositories/form_repository.dart';

class SubmitForm {
  final FormRepository repository;

  SubmitForm(this.repository);

  Future<Either<Failure, void>> call(FormData formData) async {
    return await repository.submitForm(formData);
  }
}