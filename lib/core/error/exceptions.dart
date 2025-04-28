import 'package:supabase_flutter/supabase_flutter.dart';

import 'error_message_model.dart';

class ServerException implements AuthException {
  final ErrorMessageModel errorMessageModel;
  const ServerException({
    required this.errorMessageModel,
  });

  @override
  // TODO: implement message
  String get message => errorMessageModel.statusMessage.toString();

  @override
  // TODO: implement statusCode
  String? get statusCode => errorMessageModel.statusCode.toString();

  @override
  // TODO: implement code
  String? get code => errorMessageModel.statusCode.toString();
}

