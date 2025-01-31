import 'package:dartz/dartz.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../../home_page/data/model/post_model.dart';
import '../../../welcome/data/model/user_permissions_model.dart';
import '../../data/model/add_post_response.dart';
import '../../data/model/requests/send_advise_request.dart';

abstract class LayoutRepository {
  Future<Either<FirebaseFailure, AddPostResponse>> addPost(PostModel postModel);
  Future<Either<FirebaseFailure, void>> sendAdvice(SendAdviceRequest sendAdviceRequest);
}