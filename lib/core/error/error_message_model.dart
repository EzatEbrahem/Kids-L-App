import 'package:equatable/equatable.dart';

class ErrorMessageModel extends Equatable {
  final String statusMessage;
  final String statusCode;

  const ErrorMessageModel( {required this.statusCode,
    required this.statusMessage,
  });

  @override
  List<Object?> get props => [statusCode,statusMessage];
}
