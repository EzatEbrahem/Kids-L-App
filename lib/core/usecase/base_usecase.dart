
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failure.dart';

abstract class BaseUseCase<T, Param1,Param2> {
  Future<Either<Failure, T>> call(Param1 parameters1,Param2 parameters2);
}

class NoParameters extends Equatable {
  const NoParameters();

  @override
  List<Object?> get props => [];
}