import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kids_learning/Predicting/Data/Models/predict_data_model.dart';
import 'package:kids_learning/core/error/error_message_model.dart';
import 'package:kids_learning/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../Domain/Entities/predict_data.dart';

abstract class BasePredictRemoteDataSource{
  Future<void> storePredictedData(File imageFile, PredictData predictData);
  Future<List<PredictDataModel>> getAllOldPredictedData();
  Future<List<PredictDataModel>> deleteSelectedPredictedData(String predictId);
  Future<List<PredictDataModel>> clearAllOldPredictedData();

}
class PredictRemoteDataSource extends BasePredictRemoteDataSource{
  @override
  Future<void> storePredictedData(File imageFile, PredictData predictData) async{
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storage = Supabase.instance.client.storage;
      final response = await storage
          .from('profile')
          .upload('users/${predictData.userId}/history/$fileName.png', imageFile,
          fileOptions: FileOptions(cacheControl: '3600', upsert: true));
      if (response.isNotEmpty) {
        final imageUrl = storage
            .from('profile')
            .getPublicUrl('users/${predictData.userId}/history/$fileName.png');

        final PredictDataModel data = PredictDataModel(
            userId:predictData.userId ,
            predictingName:predictData.predictingName ,
            predictingImage:imageUrl ,
            uploadedAt: FieldValue.serverTimestamp(),
            predictId:''
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(predictData.userId)
            .collection('history')
            .add(data.toMap());

        print("Image uploaded and added to history successfully!");
      } else {
        throw ServerException(errorMessageModel: ErrorMessageModel(statusCode: '', statusMessage: 'Predicting failed'));
      }
    }on FirebaseException  catch (e) {
      throw ServerException(errorMessageModel: ErrorMessageModel(statusCode: e.code, statusMessage: 'Predicting failed'));
    }
  }

  @override
  Future<List<PredictDataModel>> getAllOldPredictedData() async{
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      if (userId == null){
        throw ServerException(errorMessageModel: ErrorMessageModel(statusCode: '', statusMessage: 'Failed to load data, Tray again later'));
      }
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('history')
          .orderBy('uploadedAt', descending: true)
          .get();
      final List<PredictDataModel> listData;
      if(snapshot.docs.isNotEmpty){
        listData = snapshot.docs
            .map((doc) => PredictDataModel.fromJson(doc.data(),doc.id))
            .toList();
      }
      else{
        listData=[];
      }
      return listData;
    } on FirebaseException  catch (e) {
      throw ServerException(errorMessageModel: ErrorMessageModel(statusCode: e.code, statusMessage: 'Failed to load data, Tray again later'));

    }
  }

  @override
  Future<List<PredictDataModel>> clearAllOldPredictedData()async {
    try {

      final userId = FirebaseAuth.instance.currentUser!.uid;
      final collectionRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('history');
      final snapshots = await collectionRef.get();
      for (final doc in snapshots.docs) {
        await doc.reference.delete();
      }
      return await getAllOldPredictedData();

    } on FirebaseException  catch (e) {
      throw ServerException(errorMessageModel: ErrorMessageModel(statusCode: e.code, statusMessage: 'Failed to delete data, Tray again later'));

    }
  }

  @override
  Future<List<PredictDataModel>> deleteSelectedPredictedData(String predictId)async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('history')
          .doc(predictId)
          .delete();
     return await  getAllOldPredictedData();

    }on FirebaseException  catch (e) {
      throw ServerException(errorMessageModel: ErrorMessageModel(statusCode: e.code, statusMessage: 'Failed to delete data, Tray again later'));

    }
  }

}