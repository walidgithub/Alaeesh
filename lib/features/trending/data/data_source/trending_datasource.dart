import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:last/features/trending/data/model/requests/get_suggested_user_posts_request.dart';
import 'package:last/features/trending/data/model/suggested_user_model.dart';
import '../../../../core/di/di.dart';
import '../../../home_page/data/model/comments_model.dart';
import '../../../home_page/data/model/home_page_model.dart';
import '../../../home_page/data/model/post_model.dart';
import '../../../home_page/data/model/subscribers_model.dart';
import '../model/requests/check_if_user_subscribed_request.dart';
import '../model/requests/get_post_data_request.dart';
import '../model/requests/get_top_posts_request.dart';

abstract class BaseDataSource {
  Future<List<HomePageModel>> getTopPosts(
      GetTopPostsRequest getTopPostsRequest);
  Future<bool> checkIfUserSubscribed(CheckIfUserSubscribedRequest checkIfUserSubscribedRequest);
  Future<List<SuggestedUserModel>> getSuggestedUsers();
  Future<List<HomePageModel>> getSuggestedUserPosts(
      GetSuggestedUserPostsRequest getSuggestedUserPostsRequest);
}

class TrendingDataSource extends BaseDataSource {
  final FirebaseFirestore firestore = sl<FirebaseFirestore>();

  @override
  Future<List<HomePageModel>> getTopPosts(
      GetTopPostsRequest getTopPostsRequest) async {
    try {
      final Future<QuerySnapshot<Map<String, dynamic>>> postsFuture;

      postsFuture = firestore
          .collection('posts')
          .get();

      final subscribersFuture = firestore
          .collection('subscribers')
          .where('username', isEqualTo: getTopPostsRequest.currentUser.trim())
          .get();

      final results = await Future.wait([postsFuture, subscribersFuture]);

      // Parse the data
      final postDocs = results[0].docs;
      final subscriberDocs = results[1].docs;

      // Convert Firestore documents to PostModel and SubscribersModel lists
      final postModels = postDocs.map((doc) {
        final postData = {'id': doc.id, ...doc.data()};
        return PostModel.fromMap(postData);
      }).toList();

      final subscriberModels = subscriberDocs.map((doc) {
        final subscriberData = {
          'id': doc.id,
          ...doc.data()
        };
        return SubscribersModel.fromMap(subscriberData);
      }).toList();

      // Combine data into HomePageModel
      List<HomePageModel> homePageModels = postModels.map((post) {
        final isSubscribed = subscriberModels.any((subscriber) =>
            subscriber.postAuther == post.username); // Match post author
        return HomePageModel(postModel: post, userSubscribed: isSubscribed);
      }).toList();

      // Sort homePageModels by the count of subscribersList in descending order
      homePageModels.sort((a, b) => b.postModel.postSubscribersList.length
          .compareTo(a.postModel.postSubscribersList.length));

      return homePageModels;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<SuggestedUserModel>> getSuggestedUsers() async {
    try {
      final snapshot = await firestore.collection('posts').get();

      final posts =
          snapshot.docs.map((doc) => PostModel.fromMap(doc.data())).toList();

      final Map<String, SuggestedUserModel> userMap = {};

      for (var post in posts) {
        for (var subscriber in post.postSubscribersList) {
          final userName = subscriber.username;
          final userImage = subscriber.userImage;

          if (userMap.containsKey(userName)) {
            userMap[userName]!.subscriptionsCount++;
          } else {
            userMap[userName] = SuggestedUserModel(
              userName: userName,
              userImage: userImage,
              subscriptionsCount: 1,
            );
          }
        }
      }

      final suggestedUsers = userMap.values.toList()
        ..sort((a, b) => b.subscriptionsCount.compareTo(a.subscriptionsCount));

      return suggestedUsers;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<HomePageModel>> getSuggestedUserPosts(
      GetSuggestedUserPostsRequest getSuggestedUserPostsRequest) async {
    try {
      final collection = firestore.collection('posts');

      // Fetch posts where username matches
      final usernameQuerySnapshot = await collection
          .where('username', isEqualTo: getSuggestedUserPostsRequest.userName)
          .get();
      final postsByUsername = usernameQuerySnapshot.docs.map((doc) => PostModel.fromMap(doc.data())).toList();

      // Fetch all posts (for filtering in array fields)
      final allPostsSnapshot = await collection.get();
      final allPosts = allPostsSnapshot.docs.map((doc) => PostModel.fromMap(doc.data())).toList();

      // Search in commentsList
      final postsByComments = allPosts.where((post) {
        return post.commentsList.any((comment) => comment.username == getSuggestedUserPostsRequest.userName);
      }).toList();

      // Search in emojisList
      final postsByEmojis = allPosts.where((post) {
        return post.emojisList.any((emoji) => emoji.username == getSuggestedUserPostsRequest.userName);
      }).toList();

      // Search in commentsList within emojisList
      final postsByNestedComments = allPosts.where((post) {
        return post.emojisList.any((emoji) =>
        emoji is CommentsModel &&
            (emoji as CommentsModel).username == getSuggestedUserPostsRequest.userName);
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
        final userSubscribed = post.postSubscribersList.any((subscriber) => subscriber.username == getSuggestedUserPostsRequest.userName);
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

  @override
  Future<bool> checkIfUserSubscribed(CheckIfUserSubscribedRequest checkIfUserSubscribedRequest) async {
    try {
      var docs = await firestore.collection('subscribers')
          .where('postAuther', isEqualTo: checkIfUserSubscribedRequest.postAuther)
          .where('username', isEqualTo: checkIfUserSubscribedRequest.userName)
          .get();

      return docs.docs.isNotEmpty;
    } catch(e) {
      rethrow;
    }
  }
}
