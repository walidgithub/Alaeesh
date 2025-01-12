import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/di/di.dart';
import '../../../home_page/data/model/comments_model.dart';
import '../../../home_page/data/model/home_page_model.dart';
import '../../../home_page/data/model/post_model.dart';
import '../model/requests/get_my_activities_request.dart';

abstract class BaseDataSource {
  Future<List<HomePageModel>> getMyActivities(
      GetMyActivitiesRequest getMyActivitiesRequest);
}

class GetMyActivitiesDataSource extends BaseDataSource {
  final FirebaseFirestore firestore = sl<FirebaseFirestore>();

  @override
  Future<List<HomePageModel>> getMyActivities(GetMyActivitiesRequest getMyActivitiesRequest) async {
    try {
      final collection = firestore.collection('posts');

      // Fetch posts where username matches
      final usernameQuerySnapshot = await collection
          .where('username', isEqualTo: getMyActivitiesRequest.userName)
          .get();
      final postsByUsername = usernameQuerySnapshot.docs.map((doc) => PostModel.fromMap(doc.data())).toList();

      // Fetch all posts (for filtering in array fields)
      final allPostsSnapshot = await collection.get();
      final allPosts = allPostsSnapshot.docs.map((doc) => PostModel.fromMap(doc.data())).toList();

      // Search in commentsList
      final postsByComments = allPosts.where((post) {
        return post.commentsList.any((comment) => comment.username == getMyActivitiesRequest.userName);
      }).toList();

      // Search in emojisList
      final postsByEmojis = allPosts.where((post) {
        return post.emojisList.any((emoji) => emoji.username == getMyActivitiesRequest.userName);
      }).toList();

      // Search in commentsList within emojisList
      final postsByNestedComments = allPosts.where((post) {
        return post.emojisList.any((emoji) =>
        emoji is CommentsModel &&
            (emoji as CommentsModel).username == getMyActivitiesRequest.userName);
      }).toList();

      // Combine all results
      final combinedPosts = [
        ...postsByUsername,
        ...postsByComments,
        ...postsByEmojis,
        ...postsByNestedComments,
      ];

      // Remove duplicates
      final distinctPosts = combinedPosts.toSet().toList();

      // Convert to HomePageModel
      final homePageModels = distinctPosts.map((post) {
        final userSubscribed = post.postSubscribersList.any((subscriber) => subscriber.username == getMyActivitiesRequest.userName);
        return HomePageModel(
          postModel: post,
          userSubscribed: userSubscribed,
        );
      }).toList();

      return homePageModels;
    } catch (e) {
      rethrow;
    }
  }
}