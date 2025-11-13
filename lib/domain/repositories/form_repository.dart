import 'package:dartz/dartz.dart';
import 'package:mmf/core/error/failures.dart';
import 'package:mmf/domain/entities/form_data.dart';

abstract class FormRepository {
  Future<Either<Failure, void>> submitForm(FormData formData);
}