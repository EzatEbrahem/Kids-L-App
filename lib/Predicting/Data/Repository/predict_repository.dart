import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:kids_learning/Predicting/Data/DataSource/remote_data_source.dart';
import 'package:kids_learning/Predicting/Domain/Entities/predict_data.dart';
import 'package:kids_learning/Predicting/Domain/Repository/base_predict_repository.dart';
import 'package:kids_learning/core/error/exceptions.dart';
import 'package:kids_learning/core/error/failure.dart';

class PredictRepository extends BasePredictRepository{
  final BasePredictRemoteDataSource basePredictRemoteDataSource;
  PredictRepository(this.basePredictRemoteDataSource);

  @override
  Future<Either<Failure, void>> storePredictedData(File imageFile, PredictData predictData) async{
    try {
      final result = await basePredictRemoteDataSource.storePredictedData(imageFile, predictData);
      return Right(result);
    }on ServerException catch(e){
      return Left(ServerFailure(e.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, List<PredictData>>> getAllOldPredictData()async {
    try {
      final result = await basePredictRemoteDataSource.getAllOldPredictedData();
      return Right(result);
    }on ServerException catch(e){
      return Left(ServerFailure(e.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, List<PredictData>>> clearAllOldPredictedData()async {
    try{
      final result=await basePredictRemoteDataSource.clearAllOldPredictedData();
      return Right(result);
    }on ServerException catch(e){
      return Left(ServerFailure(e.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, List<PredictData>>> deleteSelectedPredictedData(String predictId)async {
    try{
      final result=await basePredictRemoteDataSource.deleteSelectedPredictedData(predictId);
      return Right(result);
    }on ServerException catch(e){
      return Left(ServerFailure(e.errorMessageModel.statusMessage));
    }
  }

}