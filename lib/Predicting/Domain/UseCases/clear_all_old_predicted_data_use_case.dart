import 'package:dartz/dartz.dart';
import 'package:kids_learning/Predicting/Domain/Entities/predict_data.dart';
import 'package:kids_learning/Predicting/Domain/Repository/base_predict_repository.dart';
import 'package:kids_learning/core/error/failure.dart';
import 'package:kids_learning/core/usecase/base_usecase.dart';

class ClearAllOldPredictedDataUseCase extends BaseUseCase<List<PredictData>,NoParameters,NoParameters>{
  final BasePredictRepository basePredictRepository;
  ClearAllOldPredictedDataUseCase(this.basePredictRepository);
  @override
  Future<Either<Failure, List<PredictData>>> call(NoParameters parameters1, NoParameters parameters2) async{
    return await basePredictRepository.clearAllOldPredictedData();
  }

}