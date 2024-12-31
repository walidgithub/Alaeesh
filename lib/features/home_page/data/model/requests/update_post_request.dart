import 'package:last/features/home_page/data/model/post_model.dart';

class UpdatePostRequest {
  String postId;
  PostModel postModel;
  UpdatePostRequest({required this.postId,required this.postModel});
}