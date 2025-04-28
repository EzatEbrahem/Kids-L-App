import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:kids_learning/Predicting/Domain/Entities/predict_data.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../../core/utils/enums.dart';

class PredictState extends Equatable{
  final File? imageFile;
  final PredictedResultState  predictedResultState;
  final String predictName;
  final String  errorPredictedMessage;
  final Interpreter? interpreter;
  final List<String> predictedLabels;
  final int currentIndexHelpScreen;
  final List<String> dataHelpScreen;
  final List<PredictData> listPredictedData;
  final LoadAllOldPredictedDataState loadAllOldPredictedDataState;
  final String errorLoadAllOldPredictedDataMessage;
  final DeletePredictedDataState deletePredictedDataState;

  PredictState(
      {this.predictName='',
        this.imageFile=null,
        this.deletePredictedDataState=DeletePredictedDataState.initial,
       this.predictedResultState=PredictedResultState.initial,
       this.errorPredictedMessage='',
       this.interpreter,
       this.predictedLabels=const[],
       this.currentIndexHelpScreen=0,
       this.dataHelpScreen=const['assets/signUpScreen.jpg','assets/signInScreen.jpg',
  'assets/homeScreen.jpg','assets/profileScreen.jpg',
  'assets/predictingScreen.jpg','assets/resultScreen.jpg',
  'assets/seeMoreScreen.jpg','assets/historyScreen.jpg',
  'assets/historyDetailsScreen.jpg','assets/emptyHistoryScreen.jpg'
  ],
       this.listPredictedData=const[],
       this.loadAllOldPredictedDataState=LoadAllOldPredictedDataState.initial,
       this.errorLoadAllOldPredictedDataMessage=''
      });
PredictState copyWith({
  DeletePredictedDataState? deletePredictedDataState,
  String?predictName,
   File? imageFile,
   PredictedResultState?  predictedResultState,
   String?  errorPredictedMessage,
   Interpreter? interpreter,
   List<String>? predictedLabels,
   int? currentIndexHelpScreen,
   List<String>? dataHelpScreen,
   List<PredictData>? listPredictedData,
   LoadAllOldPredictedDataState? loadAllOldPredictedDataState,
   String? errorLoadAllOldPredictedDataMessage,
  })=>PredictState(
  interpreter: interpreter??this.interpreter,
  currentIndexHelpScreen: currentIndexHelpScreen??this.currentIndexHelpScreen,
  dataHelpScreen: dataHelpScreen??this.dataHelpScreen,
  errorLoadAllOldPredictedDataMessage: errorLoadAllOldPredictedDataMessage??this.errorLoadAllOldPredictedDataMessage,
  errorPredictedMessage: errorPredictedMessage??this.errorPredictedMessage,
  imageFile: imageFile??this.imageFile,
  listPredictedData:listPredictedData??this.listPredictedData ,
  loadAllOldPredictedDataState: loadAllOldPredictedDataState??this.loadAllOldPredictedDataState,
  predictedLabels:predictedLabels??this.predictedLabels ,
  predictedResultState: predictedResultState??this.predictedResultState,
  predictName: predictName??this.predictName,
  deletePredictedDataState: deletePredictedDataState??this.deletePredictedDataState,
);
  @override
  // TODO: implement props
  List<Object?> get props => [
    deletePredictedDataState,
    predictName,
    interpreter,
    currentIndexHelpScreen,
    dataHelpScreen,
    errorLoadAllOldPredictedDataMessage,
    errorPredictedMessage,
    imageFile,
    listPredictedData,
    loadAllOldPredictedDataState,
    predictedLabels,
    predictedResultState
  ];

}