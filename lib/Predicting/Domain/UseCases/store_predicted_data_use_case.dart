import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:kids_learning/Predicting/Domain/Repository/base_predict_repository.dart';
import 'package:kids_learning/core/error/failure.dart';
import 'package:kids_learning/core/usecase/base_usecase.dart';

import '../Entities/predict_data.dart';

class StorePredictedDataUseCase extends BaseUseCase<void,File,PredictData>{
  final BasePredictRepository basePredictRepository;

   StorePredictedDataUseCase(this.basePredictRepository);

  @override
  Future<Either<Failure, void>> call(File image, PredictData predictData)async {
    return await basePredictRepository.storePredictedData(image, predictData);
  }
}