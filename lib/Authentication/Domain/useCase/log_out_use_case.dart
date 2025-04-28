import 'package:dartz/dartz.dart';
import 'package:kids_learning/Authentication/Domain/repository/base_authentication_repository.dart';
import 'package:kids_learning/core/error/failure.dart';
import 'package:kids_learning/core/usecase/base_usecase.dart';

class LogOutAuthenticationUseCase extends BaseUseCase<String,NoParameters,NoParameters>{
  final BaseAuthenticationRepository baseAuthenticationRepository;
  LogOutAuthenticationUseCase(this.baseAuthenticationRepository);

  @override
  Future<Either<Failure, String>> call(NoParameters parameters1, NoParameters parameters2) async {
   return await baseAuthenticationRepository.logOutAuthentication();
  }
}