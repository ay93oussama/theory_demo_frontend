import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../data/datasources/theory_progress_remote_data_source.dart';
import '../../data/repositories/theory_progress_repository_impl.dart';
import '../../domain/repositories/theory_progress_repository.dart';
import '../../domain/usecases/get_theory_progress_use_case.dart';
import '../../presentation/cubits/theory_progress/theory_progress_cubit.dart';
import '../config/app_config.dart';
import '../network/dio_client.dart';

final getIt = GetIt.instance;

void configureDependencies(AppConfig config) {
  getIt.registerSingleton<AppConfig>(config);
  getIt.registerLazySingleton<Dio>(() => createDio(getIt()), dispose: (dio) => dio.close());
  getIt.registerLazySingleton(() => TheoryProgressRemoteDataSource(getIt()));
  getIt.registerLazySingleton<TheoryProgressRepository>(() => TheoryProgressRepositoryImpl(getIt()));
  getIt.registerLazySingleton(() => GetTheoryProgressUseCase(getIt()));
  getIt.registerFactory(() => TheoryProgressCubit(getIt(), config: getIt()));
}
