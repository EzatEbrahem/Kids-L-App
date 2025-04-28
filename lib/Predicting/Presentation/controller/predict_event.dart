
import 'package:equatable/equatable.dart';

abstract class PredictEvent extends Equatable{

  @override
  List<Object> get props =>[];
}
class TakePictureFromGalleryToClassificationEvent extends PredictEvent{}
class TakePictureFromCameraToClassificationEvent extends PredictEvent{}
class GetAllOldPredictedDataEvent extends PredictEvent {}
class LoadClassificationModelEvent extends PredictEvent{}
class SpeakPredictedImageNameEvent extends PredictEvent{
  final String imageName;
  SpeakPredictedImageNameEvent(this.imageName);
}
class ResetHomeEvent extends PredictEvent{}
class NavigateHelpScreenEvent extends PredictEvent{
  final int index;
  NavigateHelpScreenEvent(this.index);
}
class DeleteSelectedPredictedDataEvent extends PredictEvent {
  final String predictId;
  DeleteSelectedPredictedDataEvent( this.predictId);
}
class ClearAllOldPredictedDataEvent extends PredictEvent {}