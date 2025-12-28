import 'package:dartz/dartz.dart';
import 'package:mmf/core/error/failures.dart';
import 'package:mmf/data/datasources/form_remote_datasources.dart';
import 'package:mmf/domain/entities/main_form.dart';
import 'package:mmf/domain/repositories/form_repository.dart';

class FormRepositoryImpl implements FormRepository {
  final FormRemoteDataSource remoteDataSource;

  FormRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> submitForm(MainForm mainForm) async {
    try {
      await remoteDataSource.submitForm(mainForm);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}