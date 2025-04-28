import 'package:equatable/equatable.dart';

class PredictData extends Equatable{
  final String userId;
  final String predictingImage;
  final String predictingName;
  final  dynamic uploadedAt;
  final  String predictId;

  const PredictData({
    required this.userId,
    required this.predictingImage,
    required this.predictingName,
    required this.uploadedAt,
    required this.predictId,
      });

  @override
  // TODO: implement props
  List<Object?> get props => [userId,predictingImage,predictingName,uploadedAt,predictId];
}