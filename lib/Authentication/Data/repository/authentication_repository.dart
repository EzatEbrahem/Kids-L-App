import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:kids_learning/Authentication/Data/dataSource/remote_data_source.dart';
import 'package:kids_learning/Authentication/Domain/entities/user_entities.dart';
import 'package:kids_learning/Authentication/Domain/repository/base_authentication_repository.dart';
import 'package:kids_learning/core/error/exceptions.dart';
import 'package:kids_learning/core/error/failure.dart';

class AuthenticationRepository extends BaseAuthenticationRepository{
  final BaseAuthenticationRemoteDataSource baseAuthenticationRemoteDataSource;
  AuthenticationRepository(this.baseAuthenticationRemoteDataSource);
  @override
  Future<Either<Failure, UserData>> emailAndPasswordSignInAuthentication(SignInParameters parameters)async {
   try{
   final result=await baseAuthenticationRemoteDataSource.emailAndPasswordSignInAuthentication(parameters);
     return Right(result);
   }on ServerException catch(e){
     return Left(ServerFailure(e.errorMessageModel.statusMessage));
   }
  }

  @override
  Future<Either<Failure, UserData>> facebookSignInAuthentication()async {
    try{
      final result=await baseAuthenticationRemoteDataSource.facebookSignInAuthentication();
      return Right(result);
    }on ServerException catch(e){
      return Left(ServerFailure(e.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, String>> forgetPasswordAuthentication(String email) async {
    try{
      final result=await baseAuthenticationRemoteDataSource.forgetPasswordAuthentication(email);
      return Right(result);
    }on ServerException catch(e){
      return Left(ServerFailure(e.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, UserData>> googleSignInAuthentication() async {
    try{
      final result=await baseAuthenticationRemoteDataSource.googleSignInAuthentication();
      return Right(result);
    }on ServerException catch(e){
      return Left(ServerFailure(e.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, void>> signUpAuthentication(UserData user,File? image)async {
    try{
      final result=await baseAuthenticationRemoteDataSource.signUpAuthentication(user, image);
      return Right(result);
    }on ServerException catch(e){
      return Left(ServerFailure(e.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, UserData>> getUserData() async {
    try{
      final result=await baseAuthenticationRemoteDataSource.getUserData();
      return Right(result);
    }on ServerException catch(e){
      return Left(ServerFailure(e.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, String>> logOutAuthentication() async {
    try{
      final result=await baseAuthenticationRemoteDataSource.logOutAuthentication();
      return Right(result);
    }on ServerException catch(e){
      return Left(ServerFailure(e.errorMessageModel.statusMessage));
    }
  }

}