import 'package:dartz/dartz.dart';
import 'package:last/features/welcome/data/model/user_model.dart';

import '../../../../core/firebase/error/firebase_failure.dart';

abstract class WelcomeRepository {
  Future<Either<FirebaseFailure, UserModel>> login();
  Future<Either<FirebaseFailure, void>> logout();
}