import 'package:dartz/dartz.dart';
import 'package:last/features/welcome/data/model/user_model.dart';
import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../repository/switch_user_repository.dart';

class SwitchUserUseCase extends FirebaseBaseUseCase<UserModel, FirebaseNoParameters> {
  final SwitchUserRepository switchUserRepository;

  SwitchUserUseCase(this.switchUserRepository);

  @override
  Future<Either<FirebaseFailure, UserModel>> call(FirebaseNoParameters parameters) async {
    return await switchUserRepository.switchUser();
  }
}