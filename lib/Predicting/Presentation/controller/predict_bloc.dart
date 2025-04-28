import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:kids_learning/Predicting/Domain/Entities/predict_data.dart';
import 'package:kids_learning/Predicting/Domain/UseCases/clear_all_old_predicted_data_use_case.dart';
import 'package:kids_learning/Predicting/Domain/UseCases/delete_selected_predict_use_case.dart';
import 'package:kids_learning/Predicting/Domain/UseCases/get_all_old_predicted_data_use_case.dart';
import 'package:kids_learning/Predicting/Domain/UseCases/store_predicted_data_use_case.dart';
import 'package:kids_learning/Predicting/Presentation/controller/predict_event.dart';
import 'package:kids_learning/Predicting/Presentation/controller/predict_state.dart';
import 'package:kids_learning/core/usecase/base_usecase.dart';
import 'package:kids_learning/core/utils/enums.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import '../../../core/network/cache_helpher.dart';

class PredictBloc extends Bloc<PredictEvent,PredictState>{
  final  StorePredictedDataUseCase storePredictedDataUseCase;
  final GetAllOldPredictedDataUseCase getAllOldPredictedDataUseCase;
  final DeleteSelectedPredictUseCase deleteSelectedPredictUseCase;
  final ClearAllOldPredictedDataUseCase clearAllOldPredictedDataUseCase;
  PredictBloc(this.storePredictedDataUseCase, this.getAllOldPredictedDataUseCase,
      this.deleteSelectedPredictUseCase, this.clearAllOldPredictedDataUseCase):super(PredictState()){
    on<TakePictureFromCameraToClassificationEvent>((event, emit)async {
      final ImagePicker _picker = ImagePicker();
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,

      );
      if (pickedFile != null&& state.interpreter != null && state.predictedLabels.isNotEmpty) {
        emit(state.copyWith(
            predictedResultState: PredictedResultState.loading
        ));
        final predictName=await classifyImage( File(pickedFile.path),state.interpreter!,state.predictedLabels);
        final userId=CacheHelper().getData(key: 'userId');
        final result = await storePredictedDataUseCase(File(pickedFile.path),
            new PredictData(userId: userId, predictingImage: '', predictingName: predictName,uploadedAt: '', predictId: ''));
        result.fold(
                (l)=>emit(state.copyWith(
                  imageFile: null,
                  predictedResultState:PredictedResultState.error ,
                  errorPredictedMessage: l.message,
                )),
            (r)=>emit(state.copyWith(
              predictedResultState:PredictedResultState.loaded ,imageFile: File(pickedFile.path),predictName: predictName)),
        );

      }else{
        emit(state.copyWith(
          imageFile: null,
          predictedResultState:PredictedResultState.error ,

        ));
      }

    },);
    on<TakePictureFromGalleryToClassificationEvent>((event, emit)async {
      final ImagePicker _picker = ImagePicker();
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,

      );
      if (pickedFile != null&& state.interpreter != null && state.predictedLabels.isNotEmpty) {
        emit(state.copyWith(
            predictedResultState: PredictedResultState.loading
        ));
        final predictName=await classifyImage( File(pickedFile.path),state.interpreter!,state.predictedLabels);
        final userId=CacheHelper().getData(key: 'userId');
        final result = await storePredictedDataUseCase(File(pickedFile.path),
            new PredictData(userId: userId, predictingImage: '', predictingName: predictName,uploadedAt: '', predictId: ''));
        result.fold(
                (l)=>emit(state.copyWith(
                  imageFile: null,
                  predictedResultState:PredictedResultState.error ,
                  errorPredictedMessage: l.message,
                )),
            (r)=>emit(state.copyWith(
              predictedResultState:PredictedResultState.loaded ,imageFile: File(pickedFile.path),predictName: predictName)),
        );

      }else{
        emit(state.copyWith(
          imageFile: null,
          predictedResultState:PredictedResultState.error ,

        ));
      }

    },);
    on<LoadClassificationModelEvent>((event, emit) async {
      final Interpreter _interpreter = await Interpreter.fromAsset('tflite/efficientnet-lite0-fp32.tflite');
      final labelData = await rootBundle.loadString('assets/tflite/efficientnet-lite0-fp32.txt');
      final _labels = labelData.split('\n');
      final labels = _labels.sublist(1);
      emit(state.copyWith(
          interpreter: _interpreter,
          predictedLabels: labels
      ));
    },);
    on<SpeakPredictedImageNameEvent>((event, emit) async {
      final FlutterTts flutterTts = FlutterTts();
      if (event.imageName.isNotEmpty) {
        await flutterTts.setLanguage("en-US");
        await flutterTts.setPitch(2);
        await flutterTts.setSpeechRate(0.3);
        await flutterTts.speak(event.imageName);
      }
    },);
    on<ResetHomeEvent>((event, emit) {
      emit(state.copyWith(
        predictName: '',
        imageFile: null,
        predictedResultState: PredictedResultState.initial,
      ));
    },);
    on<NavigateHelpScreenEvent>((event, emit) {
      emit(state.copyWith(
        currentIndexHelpScreen: event.index,
      ));
    },);
    on<GetAllOldPredictedDataEvent>((event, emit) async {
      emit(state.copyWith(loadAllOldPredictedDataState: LoadAllOldPredictedDataState.loading));
      final result =await getAllOldPredictedDataUseCase(NoParameters(),NoParameters());
      result.fold(
              (l)=>emit(state.copyWith(
                  loadAllOldPredictedDataState: LoadAllOldPredictedDataState.error,
                errorLoadAllOldPredictedDataMessage: l.message,
              )),
          (r)=>emit(state.copyWith(
            loadAllOldPredictedDataState: LoadAllOldPredictedDataState.loaded,
            deletePredictedDataState: DeletePredictedDataState.initial,
            listPredictedData: r,
          )),
      );
    },);
    on<DeleteSelectedPredictedDataEvent>((event, emit) async {
      emit(state.copyWith(loadAllOldPredictedDataState: LoadAllOldPredictedDataState.loading));
      emit(state.copyWith(deletePredictedDataState: DeletePredictedDataState.loading));
      final result = await deleteSelectedPredictUseCase(event.predictId,NoParameters());
      result.fold(
            (l)=>emit(state.copyWith(
          loadAllOldPredictedDataState: LoadAllOldPredictedDataState.error,
          deletePredictedDataState: DeletePredictedDataState.error,
          errorLoadAllOldPredictedDataMessage: l.message,
        )),
            (r)=>emit(state.copyWith(
              deletePredictedDataState: DeletePredictedDataState.loaded,
          loadAllOldPredictedDataState: LoadAllOldPredictedDataState.loaded,
          listPredictedData: r,
        )),
      );
    },);
    on<ClearAllOldPredictedDataEvent>((event, emit) async {
      emit(state.copyWith(loadAllOldPredictedDataState: LoadAllOldPredictedDataState.loading));
      emit(state.copyWith(deletePredictedDataState: DeletePredictedDataState.loading));
      final result = await clearAllOldPredictedDataUseCase(NoParameters(),NoParameters());
      result.fold(
            (l)=>emit(state.copyWith(
          loadAllOldPredictedDataState: LoadAllOldPredictedDataState.error,
          deletePredictedDataState: DeletePredictedDataState.error,
          errorLoadAllOldPredictedDataMessage: l.message,
        )),
            (r)=>emit(state.copyWith(
              deletePredictedDataState: DeletePredictedDataState.loaded,
          loadAllOldPredictedDataState: LoadAllOldPredictedDataState.loaded,
          listPredictedData: r,
        )),
      );
    },);

  }
  Future<String> classifyImage(File photo,Interpreter interpreter,List<String> labels)async {

    final bytes = await photo.readAsBytes();
    final image = img.decodeImage(bytes)!;
    final resizedImage = img.copyResize(image, width: 224, height: 224);
    TensorImage tensorImage = TensorImage(TfLiteType.float32);
    tensorImage.loadImage(resizedImage);
    final processor = ImageProcessorBuilder()
        .add(ResizeOp(224, 224, ResizeMethod.BILINEAR))
        .add(NormalizeOp(127.5, 127.5))
        .build();
    tensorImage = processor.process(tensorImage);
    final outputShape = interpreter.getOutputTensor(0).shape;
    final outputType = interpreter.getOutputTensor(0).type;
    TensorBuffer outputBuffer = TensorBuffer.createFixedSize(outputShape, outputType);
    interpreter.run(tensorImage.buffer, outputBuffer.buffer);
    final labeledProb = TensorLabel.fromList(labels, outputBuffer).getMapWithFloatValue();
    final topResult = labeledProb.entries.reduce((a, b) => a.value > b.value ? a : b);
    return topResult.key;
  }

}