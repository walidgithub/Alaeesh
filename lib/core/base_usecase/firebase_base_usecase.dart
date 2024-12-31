import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

import '../firebase/error/firebase_failure.dart';

abstract class FirebaseBaseUseCase<T, Parameters> {
  Future<Either<FirebaseFailure, T>> call(Parameters parameters);
}

class FirebaseNoParameters extends Equatable {
  const FirebaseNoParameters();
  @override
  List<Object?> get props => [];
}