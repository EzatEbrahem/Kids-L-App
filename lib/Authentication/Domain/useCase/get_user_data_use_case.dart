import 'package:dartz/dartz.dart';
import 'package:kids_learning/Authentication/Domain/entities/user_entities.dart';
import 'package:kids_learning/Authentication/Domain/repository/base_authentication_repository.dart';
import 'package:kids_learning/core/error/failure.dart';
import 'package:kids_learning/core/usecase/base_usecase.dart';

class GetUserDataUseCase extends BaseUseCase<UserData,NoParameters,NoParameters>{
  final BaseAuthenticationRepository baseAuthenticationRepository;
  GetUserDataUseCase(this.baseAuthenticationRepository);
  @override
  Future<Either<Failure, UserData>> call(NoParameters parameter,NoParameters noParameter) async {
   return await baseAuthenticationRepository.getUserData();
  }

}