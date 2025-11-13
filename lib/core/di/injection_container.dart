import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mmf/data/datasources/form_remote_datasources.dart';
import 'package:mmf/data/repositories/form_repository_impl.dart';
import 'package:mmf/domain/repositories/form_repository.dart';
import 'package:mmf/domain/usecases/submit_form.dart';
import 'package:mmf/presentation/cubits/form_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Cubit
  sl.registerFactory(() => FormCubit(submitForm: sl()));

  // Use cases
  sl.registerLazySingleton(() => SubmitForm(sl()));

  // Repository
  sl.registerLazySingleton<FormRepository>(
    () => FormRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<FormRemoteDataSource>(
    () => FormRemoteDataSourceImpl(client: sl()),
  );

  // External
  sl.registerLazySingleton(() => http.Client());
}