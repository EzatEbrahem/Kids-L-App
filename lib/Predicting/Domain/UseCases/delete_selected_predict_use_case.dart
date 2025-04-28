import 'package:dartz/dartz.dart';
import 'package:kids_learning/Predicting/Domain/Entities/predict_data.dart';
import 'package:kids_learning/Predicting/Domain/Repository/base_predict_repository.dart';
import 'package:kids_learning/core/error/failure.dart';
import 'package:kids_learning/core/usecase/base_usecase.dart';

class DeleteSelectedPredictUseCase extends BaseUseCase<List<PredictData>,String,NoParameters> {
  final BasePredictRepository basePredictRepository;
  DeleteSelectedPredictUseCase(this.basePredictRepository);

  @override
  Future<Either<Failure, List<PredictData>>> call(String predictId, NoParameters parameters2) async{
    return await basePredictRepository.deleteSelectedPredictedData(predictId);
  }
}