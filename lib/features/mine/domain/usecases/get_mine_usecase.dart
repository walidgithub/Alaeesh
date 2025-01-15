import 'package:dartz/dartz.dart';

import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../../home_page/data/model/home_page_model.dart';
import '../repository/mine_repository.dart';

class GetMineUseCase extends FirebaseBaseUseCase{
  final MineRepository mineRepository;

  GetMineUseCase(this.mineRepository);

  @override
  Future<Either<FirebaseFailure, List<HomePageModel>>> call(parameters) async {
    return await mineRepository.getMine(parameters);
  }
}