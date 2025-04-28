import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kids_learning/Predicting/Domain/Entities/predict_data.dart';

class PredictDataModel extends PredictData{
  PredictDataModel({
    required super.userId,
    required super.predictingImage,
    required super.predictingName,
    required super.uploadedAt,
    required super.predictId});
  factory PredictDataModel.fromJson(Map<String,dynamic> json,String predictId)=>PredictDataModel(
      userId: json['userId'],
      predictingImage:  json['predict_image'],
      predictingName:  json['predict_name'],
      uploadedAt:  (json['uploadedAt']as Timestamp?)!.toDate(),
    predictId: predictId,
  );

   Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'predict_name': predictingName,
      'predict_image': predictingImage,
      'uploadedAt': uploadedAt,
    };
  }

}