import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../Entities/predict_data.dart';

abstract class BasePredictRepository{
  Future<Either<Failure, void>>storePredictedData(File image, PredictData predictData);
  Future<Either<Failure, List<PredictData>>>getAllOldPredictData();
  Future<Either<Failure, List<PredictData>>>deleteSelectedPredictedData(String predictId);
  Future<Either<Failure, List<PredictData>>>clearAllOldPredictedData();

}