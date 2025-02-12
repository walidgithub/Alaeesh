
import '../../features/home_page/data/model/post_model.dart';

class UserPostsArguments {
  String? username;
  Function? reload;
  UserPostsArguments({this.username, this.reload});
}

class PostDataArguments {
  String? postId;
  String? username;
  PostDataArguments({this.username, this.postId});
}