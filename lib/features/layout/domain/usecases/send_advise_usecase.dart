import 'package:dartz/dartz.dart';

import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../repository/layout_repository.dart';

class SendAdviceUseCase extends FirebaseBaseUseCase{
  final LayoutRepository layoutRepository;

  SendAdviceUseCase(this.layoutRepository);

  @override
  Future<Either<FirebaseFailure, void>> call(parameters) async {
    return await layoutRepository.sendAdvice(parameters);
  }
}