import 'package:dartz/dartz.dart';
import 'package:mmf/core/error/failures.dart';
import 'package:mmf/domain/entities/main_form.dart';

abstract class FormRepository {
  Future<Either<Failure, void>> submitForm(MainForm mainForm);
}