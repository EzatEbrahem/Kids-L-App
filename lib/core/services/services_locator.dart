import 'package:get_it/get_it.dart';
import 'package:kids_learning/Authentication/Data/dataSource/remote_data_source.dart';
import 'package:kids_learning/Authentication/Data/repository/authentication_repository.dart';
import 'package:kids_learning/Authentication/Domain/repository/base_authentication_repository.dart';
import 'package:kids_learning/Authentication/Domain/useCase/email_password_sign_in_use_case.dart';
import 'package:kids_learning/Authentication/Domain/useCase/facebook_sign_in_use_case.dart';
import 'package:kids_learning/Authentication/Domain/useCase/forget_password_use_case.dart';
import 'package:kids_learning/Authentication/Domain/useCase/get_user_data_use_case.dart';
import 'package:kids_learning/Authentication/Domain/useCase/google_sign_in_use_case.dart';
import 'package:kids_learning/Authentication/Domain/useCase/log_out_use_case.dart';
import 'package:kids_learning/Authentication/Domain/useCase/sign_up_use_case.dart';
import 'package:kids_learning/Authentication/Presentation/contoller/authentication_bloc.dart';
import 'package:kids_learning/Predicting/Data/DataSource/remote_data_source.dart';
import 'package:kids_learning/Predicting/Data/Repository/predict_repository.dart';
import 'package:kids_learning/Predicting/Domain/Repository/base_predict_repository.dart';
import 'package:kids_learning/Predicting/Domain/UseCases/clear_all_old_predicted_data_use_case.dart';
import 'package:kids_learning/Predicting/Domain/UseCases/delete_selected_predict_use_case.dart';
import 'package:kids_learning/Predicting/Domain/UseCases/get_all_old_predicted_data_use_case.dart';
import 'package:kids_learning/Predicting/Domain/UseCases/store_predicted_data_use_case.dart';
import 'package:kids_learning/Predicting/Presentation/controller/predict_bloc.dart';

final sl=GetIt.instance;
class ServicesLocator {
  void init(){
    ///Bloc
    sl.registerFactory(()=>AuthenticationBloc(sl(),sl(),sl(),sl(),sl(),sl(),sl()));
    sl.registerFactory(()=>PredictBloc(sl(),sl(),sl(),sl()));
    ///UseCases
    sl.registerLazySingleton(()=>SignUpUseCase(sl()));
    sl.registerLazySingleton(()=>EmailAndPasswordSignInUseCase(sl()));
    sl.registerLazySingleton(()=>FacebookSignInUseCase(sl()));
    sl.registerLazySingleton(()=>GoogleSignInUseCase(sl()));
    sl.registerLazySingleton(()=>ForgetPasswordUseCase(sl()));
    sl.registerLazySingleton(()=>LogOutAuthenticationUseCase(sl()));
    sl.registerLazySingleton(()=>GetUserDataUseCase(sl()));

    sl.registerLazySingleton(()=>ClearAllOldPredictedDataUseCase(sl()));
    sl.registerLazySingleton(()=>DeleteSelectedPredictUseCase(sl()));
    sl.registerLazySingleton(()=>GetAllOldPredictedDataUseCase(sl()));
    sl.registerLazySingleton(()=>StorePredictedDataUseCase(sl()));


    ///Repository
    sl.registerLazySingleton<BaseAuthenticationRepository>(()=>AuthenticationRepository(sl()));
    sl.registerLazySingleton<BasePredictRepository>(()=>PredictRepository(sl()));
    ///Data Source
    sl.registerLazySingleton<BaseAuthenticationRemoteDataSource>(()=>AuthenticationRemoteDataSource());
    sl.registerLazySingleton<BasePredictRemoteDataSource>(()=>PredictRemoteDataSource());
  }

}