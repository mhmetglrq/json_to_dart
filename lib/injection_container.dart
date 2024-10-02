import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:json_to_dart/features/jsonToDart/presentation/bloc/dashboard_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Dio
  sl.registerSingleton<Dio>(Dio());

  // Dependencies
  // sl.registerSingleton<GetTokenService>(GetTokenService(sl()));

  // sl.registerSingleton<RemoteTokenRepository>(RemoteTokenRepositoryImpl(sl()));

  //UseCases
  // sl.registerSingleton<GetTokenUsecase>(GetTokenUsecase(sl()));

  //Blocs
  sl.registerFactory<DashboardBloc>(() => DashboardBloc());
  // sl.registerFactory<UsersBloc>(() => UsersBloc(sl()));
  // sl.registerFactory<LocalTokenBloc>(() => LocalTokenBloc(sl(), sl()));
}
